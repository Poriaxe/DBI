# TSK Hierarchie Generator

Dieses Projekt erzeugt ein **Hierarchie-Diagramm der Türkischen Streitkräfte (TSK)** als SVG und PNG aus einer MySQL-Datenbank.

---

## 📦 Voraussetzungen

1. **Node.js** (Version 16 oder höher empfohlen)  
2. **MySQL**-Datenbank  
3. Node.js-Pakete (werden über `npm install` installiert)  

---

## ⚙️ Installation

1. Projektordner klonen oder entpacken  
2. Im Projektverzeichnis die Abhängigkeiten installieren:

npm install

Die package.json enthält folgende Pakete:

mysql2 – für die Datenbankverbindung

@svgdotjs/svg.js – für SVG-Erzeugung

svgdom – SVG-Unterstützung in Node.js

sharp – für PNG-Export
