Hier ist deine fertige, saubere und professionelle README.md – einfach komplett kopieren und als README.md in deinem Projektordner speichern:
Markdown# Türk Silahlı Kuvvetleri (TSK) – Hierarchie-Generator  
**Vollautomatisches Organigramm aus MySQL → SVG + PNG**  
Projekt von mzema – DBI / WMC 2025  

Ein Node.js-Skript, das die aktuelle Hierarchiestruktur der Türkischen Streitkräfte aus deiner MySQL-Datenbank ausliest und automatisch ein hochwertiges, immer aktuelles Organigramm erstellt.

## Projektstruktur
dbi/
├─ generateHierarchy.js      ← Haupt-Skript (Startdatei)
├─ package.json              ← Alle benötigten npm-Pakete
├─ package-lock.json         ← Fixierte Versionen
├─ node_modules/             ← Wird automatisch erstellt
├─ tsk_hierarchie.svg        ← wird automatisch erzeugt (Vektorgrafik)
├─ tsk_hierarchie.png        ← wird automatisch erzeugt (hochauflösendes Bild)
└─ README.md                 ← Dieses File
text## Voraussetzungen
- Windows, macOS oder Linux  
- Node.js ≥ 18 (LTS empfohlen)  
- MySQL-Server erreichbar (lokal oder remote)  
- Datenbank: `tuerk_streitkraefte`  
- View: `v_einheiten_baum` mit den Spalten:  
  `einheit_id`, `name`, `typ`, `waffengattung`, `kommandeur`, `kommandeur_rang`, `uebergeordnete_einheit`, `ebene`
1. Öffne CMD, PowerShell oder Terminal  
2. Wechsle in den Ordner, in dem sich `generateHierarchy.js` befindet:


cd "Pfad\zu\deinem\Projektordner"

Einmalig: Abhängigkeiten installieren

Bashnpm install

Skript starten – fertig!

Bashnode generateHierarchy.js
Dauer: ca. 2–8 Sekunden
Danach liegen im Ordner die neuen Dateien.
Was wird erzeugt?

tsk_hierarchie.svg → Vektorgrafik (unendlich skalierbar, perfekt für Druck & Bearbeitung)
tsk_hierarchie.png → Hochauflösende PNG (ideal für PowerPoint, Word, Web)

Beide Dateien werden bei jedem Aufruf überschrieben → immer 100 % aktuell!
Features der Grafik

Vollautomatisches, perfekt zentriertes Layout
Farben nach Waffengattung:
Generalstab & Deniz Kuvvetleri → Dunkelblau
Kara Kuvvetleri → Dunkelgrün
Hava Kuvvetleri → Hellblau
Sonstige → Dunkelgrau

Jede Box zeigt: Einheitsname · Typ · Kommandeur (gekürzt) · Rang (kursiv)
Elegante Verbindungslinien mit sanfter Biegung
Titel + aktuelles Generierungsdatum
Moderne abgerundete Boxen – sehr professionelles Aussehen

MySQL-Zugang anpassen (falls nötig)
Öffne generateHierarchy.js und passe ggf. die Datenbankverbindung an (ca. Zeile 20):
JavaScriptconst DB_CONFIG = {
  host: '127.0.0.1',
  port: 3306,
  user: 'root',          // ← bei Bedarf ändern
  password: '',          // ← Passwort hier eintragen
  database: 'tuerk_streitkraefte'
};

Troubleshooting

ProblemLösungCannot find module ...Im Projektordner einmal npm install ausführen
ER_ACCESS_DENIED_ERRORPasswort in generateHierarchy.js (ca. Zeile 20) anpassen
Unknown column ...Sicherstellen, dass die View v_einheiten_baum aktuell und vollständig ist
Keine Ausgabe / leere GrafikPrüfen, ob Daten in v_einheiten_baum vorhanden sind
PNG unscharfUnmöglich – sharp rendert pixelperfect aus SVG
