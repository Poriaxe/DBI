// generateHierarchy.js – FUNKTIONIERT 100% IN NODE.JS
const mysql = require('mysql2/promise');
const { SVG, registerWindow } = require('@svgdotjs/svg.js');
const { createSVGWindow } = require('svgdom');
const fs = require('fs').promises;
const path = require('path');
const sharp = require('sharp');

// === SVG in Node.js aktivieren ===
const window = createSVGWindow();
const document = window.document;
registerWindow(window, document);  // Jetzt funktioniert es!

// === DB ===
const DB_CONFIG = {
  host: '127.0.0.1',
  port: 3306,
  user: 'root',
  password: '',
  database: 'tuerk_streitkraefte'
};

const SVG_FILE = path.join(__dirname, 'tsk_hierarchie.svg');
const PNG_FILE = path.join(__dirname, 'tsk_hierarchie.png');

const BOX = { w: 240, h: 90 };
const SPACING = { h: 80, v: 120 };
const PADDING = 60;

async function generateHierarchy() {
  let conn;
  try {
    console.log('Verbinde mit MySQL...');
    conn = await mysql.createConnection(DB_CONFIG);
    console.log('Verbindung OK!');

    const [rows] = await conn.execute('SELECT * FROM v_einheiten_baum ORDER BY ebene, einheit_id');
    if (!rows.length) {
      console.warn('Keine Daten in v_einheiten_baum');
      return;
    }

    // === Knoten ===
    const nodes = {};
    rows.forEach(r => {
      const parentId = r.uebergeordnete_einheit
        ? rows.find(x => x.name === r.uebergeordnete_einheit)?.einheit_id
        : null;

      nodes[r.einheit_id] = {
        id: r.einheit_id,
        name: r.name,
        typ: r.typ,
        waffe: r.waffengattung,
        kom: r.kommandeur || '-',
        rang: r.kommandeur_rang || '',
        ebene: r.ebene,
        parentId,
        children: [],
        x: 0, y: 0
      };
    });

    Object.values(nodes).forEach(n => {
      if (n.parentId && nodes[n.parentId]) nodes[n.parentId].children.push(n);
    });

    // === Layout ===
    const levels = {};
    Object.values(nodes).forEach(n => {
      levels[n.ebene] = levels[n.ebene] || [];
      levels[n.ebene].push(n);
    });

    let y = PADDING;
    const maxInLevel = Math.max(...Object.values(levels).map(l => l.length), 1);
    const width = Math.max(1200, maxInLevel * (BOX.w + SPACING.h) + PADDING * 2);

    Object.keys(levels).sort((a, b) => a - b).forEach(lvl => {
      const nodesInLvl = levels[lvl];
      const totalW = nodesInLvl.length * (BOX.w + SPACING.h) - SPACING.h;
      let x = (width - totalW) / 2;

      nodesInLvl.forEach(n => {
        n.x = x;
        n.y = y;
        x += BOX.w + SPACING.h;
      });
      y += BOX.h + SPACING.v;
    });

    const height = y + PADDING;

    // === SVG ===
    const draw = SVG(document.documentElement).size(width, height);
    draw.rect(width, height).fill('#f8f9fa');

    draw.text('Türk Silahlı Kuvvetleri (TSK) – Hierarchie')
        .font({ size: 22, weight: 'bold', family: 'Arial' })
        .fill('#1a1a1a')
        .center(width / 2, 25);

    draw.text(`Generiert: ${new Date().toLocaleString('de-AT')}`)
        .font({ size: 12 })
        .fill('#666')
        .move(width - 300, height - 30);

    // Linien
    Object.values(nodes).forEach(n => {
      if (n.parentId && nodes[n.parentId]) {
        const p = nodes[n.parentId];
        const x1 = p.x + BOX.w / 2, y1 = p.y + BOX.h;
        const x2 = n.x + BOX.w / 2, y2 = n.y;
        draw.polyline([x1, y1, x1, y1 + 40, x2, y2 - 40, x2, y2])
            .fill('none')
            .stroke({ color: '#666', width: 2 });
      }
    });

    // Boxen
    Object.values(nodes).forEach(n => {
      const g = draw.group();
      g.rect(BOX.w, BOX.h).radius(12).fill(color(n.waffe)).stroke('#222');
      g.text(n.name).font({ size: 15, weight: 'bold', fill: '#fff' }).move(14, 12);
      g.text(n.typ).font({ size: 12, fill: '#e3f2fd' }).move(14, 34);
      g.text(`Kom: ${n.kom.substring(0, 18)}${n.kom.length > 18 ? '...' : ''}`)
         .font({ size: 11, fill: '#fff' }).move(14, 54);
      if (n.rang) g.text(n.rang).font({ size: 10, style: 'italic', fill: '#ffcc80' }).move(14, 72);
      g.move(n.x, n.y);
    });

    // === Export SVG ===
    const svg = draw.svg();
    await fs.writeFile(SVG_FILE, svg);
    console.log(`SVG: ${SVG_FILE}`);

    // === PNG direkt mit Sharp ===
    await sharp(Buffer.from(svg))
      .png()
      .toFile(PNG_FILE);
    console.log(`PNG: ${PNG_FILE}`);

    console.log('\nFERTIG! Öffne die Dateien.');

  } catch (err) {
    console.error('FEHLER:', err.message);
  } finally {
    if (conn) await conn.end();
  }
}

function color(w) {
  return {
    'Türk Silahlı Kuvvetleri Genel': '#0d47a1',
    'Kara Kuvvetleri': '#1b5e20',
    'Deniz Kuvvetleri': '#0d47a1',
    'Hava Kuvvetleri': '#1565c0'
  }[w] || '#424242';
}

generateHierarchy();
