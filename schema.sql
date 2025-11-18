-- =====================================================
-- TÜRKISCHE STREITKRÄFTE (TSK) – ORGANISATIONSSTRUKTUR
-- Für MySQL Workbench (UTF8MB4 kompatibel)
-- =====================================================

DROP DATABASE IF EXISTS tuerk_streitkraefte;
CREATE DATABASE tuerk_streitkraefte CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE tuerk_streitkraefte;

-- =====================================================
-- TABELLENDEFINITIONEN
-- =====================================================

-- Tabelle: Waffengattungen
CREATE TABLE waffengattung (
    waffengattung_id INT PRIMARY KEY AUTO_INCREMENT,
    bezeichnung VARCHAR(100) NOT NULL UNIQUE,
    abkuerzung VARCHAR(10),
    beschreibung TEXT
);

-- Tabelle: Dienstgrade
CREATE TABLE dienstgrad (
    dienstgrad_id INT PRIMARY KEY AUTO_INCREMENT,
    waffengattung_id INT NOT NULL,
    bezeichnung_tr VARCHAR(50) NOT NULL,
    bezeichnung_de VARCHAR(50),
    rang_stufe INT NOT NULL,
    kategorie ENUM('Mannschaft', 'Unteroffizier', 'Offizier', 'General') NOT NULL,
    FOREIGN KEY (waffengattung_id) REFERENCES waffengattung(waffengattung_id)
);

-- Tabelle: Einheitentypen
CREATE TABLE einheit_typ (
    typ_id INT PRIMARY KEY AUTO_INCREMENT,
    bezeichnung_tr VARCHAR(50) NOT NULL,
    bezeichnung_de VARCHAR(50),
    hierarchie_stufe INT NOT NULL UNIQUE,
    beschreibung VARCHAR(200)
);

-- Tabelle: Einheiten
CREATE TABLE einheit (
    einheit_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    waffengattung_id INT NOT NULL,
    typ_id INT NOT NULL,
    uebergeordnete_einheit_id INT,
    standort VARCHAR(100),
    kommandeur_id INT,
    FOREIGN KEY (waffengattung_id) REFERENCES waffengattung(waffengattung_id),
    FOREIGN KEY (typ_id) REFERENCES einheit_typ(typ_id),
    FOREIGN KEY (uebergeordnete_einheit_id) REFERENCES einheit(einheit_id)
);

-- Tabelle: Soldaten
CREATE TABLE soldat (
    soldat_id INT PRIMARY KEY AUTO_INCREMENT,
    vorname VARCHAR(50) NOT NULL,
    nachname VARCHAR(50) NOT NULL,
    dienstgrad_id INT NOT NULL,
    waffengattung_id INT NOT NULL,
    aktuelle_einheit_id INT,
    direkter_vorgesetzter_id INT,
    eintrittsdatum DATE NOT NULL,
    FOREIGN KEY (dienstgrad_id) REFERENCES dienstgrad(dienstgrad_id),
    FOREIGN KEY (waffengattung_id) REFERENCES waffengattung(waffengattung_id),
    FOREIGN KEY (aktuelle_einheit_id) REFERENCES einheit(einheit_id),
    FOREIGN KEY (direkter_vorgesetzter_id) REFERENCES soldat(soldat_id)
);

-- Fremdschlüssel für Kommandeur
ALTER TABLE einheit
    ADD CONSTRAINT fk_kommandeur FOREIGN KEY (kommandeur_id) REFERENCES soldat(soldat_id);

-- Tabelle: Dienstposten
CREATE TABLE dienstposten (
    dienstposten_id INT PRIMARY KEY AUTO_INCREMENT,
    bezeichnung_tr VARCHAR(100) NOT NULL,
    bezeichnung_de VARCHAR(100),
    hierarchie_stufe INT NOT NULL,
    mindest_dienstgrad_id INT,
    FOREIGN KEY (mindest_dienstgrad_id) REFERENCES dienstgrad(dienstgrad_id)
);

-- Tabelle: Soldat-Dienstposten Zuordnung
CREATE TABLE soldat_dienstposten (
    soldat_id INT NOT NULL,
    dienstposten_id INT NOT NULL,
    einheit_id INT NOT NULL,
    von_datum DATE NOT NULL,
    PRIMARY KEY (soldat_id, dienstposten_id),
    FOREIGN KEY (soldat_id) REFERENCES soldat(soldat_id),
    FOREIGN KEY (dienstposten_id) REFERENCES dienstposten(dienstposten_id),
    FOREIGN KEY (einheit_id) REFERENCES einheit(einheit_id)
);

-- =====================================================
-- DATEN EINFÜGEN
-- =====================================================

-- Waffengattungen
INSERT INTO waffengattung (bezeichnung, abkuerzung, beschreibung) VALUES
('Türk Silahlı Kuvvetleri Genel', 'TSK', 'Generalstab - Oberkommando'),
('Kara Kuvvetleri', 'KKK', 'Heer - Landstreitkräfte'),
('Deniz Kuvvetleri', 'DKK', 'Marine - Seestreitkräfte'),
('Hava Kuvvetleri', 'HKK', 'Luftwaffe - Luftstreitkräfte'),
('Jandarma', 'JGK', 'Gendarmerie - Militärpolizei'),
('Sahil Güvenlik', 'SGK', 'Küstenwache');

-- Dienstgrade - Generalstab
INSERT INTO dienstgrad (waffengattung_id, bezeichnung_tr, bezeichnung_de, rang_stufe, kategorie) VALUES
(1, 'Genelkurmay Başkanı', 'Generalstabschef', 100, 'General');

-- Dienstgrade - Heer
INSERT INTO dienstgrad (waffengattung_id, bezeichnung_tr, bezeichnung_de, rang_stufe, kategorie) VALUES
(2, 'Er', 'Soldat', 1, 'Mannschaft'),
(2, 'Onbaşı', 'Korporal', 2, 'Mannschaft'),
(2, 'Çavuş', 'Sergeant', 3, 'Unteroffizier'),
(2, 'Üstçavuş', 'Obersergent', 4, 'Unteroffizier'),
(2, 'Kıdemli Üstçavuş', 'Stabsfeldwebel', 5, 'Unteroffizier'),
(2, 'Asteğmen', 'Leutnant', 6, 'Offizier'),
(2, 'Teğmen', 'Oberleutnant', 7, 'Offizier'),
(2, 'Üsteğmen', 'Hauptmann', 8, 'Offizier'),
(2, 'Yüzbaşı', 'Stabshauptmann', 9, 'Offizier'),
(2, 'Binbaşı', 'Major', 10, 'Offizier'),
(2, 'Yarbay', 'Oberstleutnant', 11, 'Offizier'),
(2, 'Albay', 'Oberst', 12, 'Offizier'),
(2, 'Tuğgeneral', 'Brigadegeneral', 13, 'General'),
(2, 'Tümgeneral', 'Generalmajor', 14, 'General'),
(2, 'Korgeneral', 'Generalleutnant', 15, 'General'),
(2, 'Orgeneral', 'General', 16, 'General');

-- Dienstgrade - Marine
INSERT INTO dienstgrad (waffengattung_id, bezeichnung_tr, bezeichnung_de, rang_stufe, kategorie) VALUES
(3, 'Er', 'Matrose', 1, 'Mannschaft'),
(3, 'Onbaşı', 'Maat', 2, 'Mannschaft'),
(3, 'Başçavuş', 'Obermaat', 4, 'Unteroffizier'),
(3, 'Güverte Subayı', 'Leutnant zur See', 6, 'Offizier'),
(3, 'Yüzbaşı', 'Kapitänleutnant', 9, 'Offizier'),
(3, 'Binbaşı', 'Korvettenkapitän', 10, 'Offizier'),
(3, 'Albay', 'Kapitän zur See', 12, 'Offizier'),
(3, 'Tümamiral', 'Konteradmiral', 14, 'General'),
(3, 'Koramiral', 'Vizeadmiral', 15, 'General'),
(3, 'Oramiral', 'Admiral', 16, 'General');

-- Dienstgrade - Luftwaffe
INSERT INTO dienstgrad (waffengattung_id, bezeichnung_tr, bezeichnung_de, rang_stufe, kategorie) VALUES
(4, 'Er', 'Flieger', 1, 'Mannschaft'),
(4, 'Onbaşı', 'Gefreiter', 2, 'Mannschaft'),
(4, 'Astsubay', 'Feldwebel', 5, 'Unteroffizier'),
(4, 'Teğmen', 'Leutnant', 7, 'Offizier'),
(4, 'Yüzbaşı', 'Hauptmann', 9, 'Offizier'),
(4, 'Binbaşı', 'Major', 10, 'Offizier'),
(4, 'Albay', 'Oberst', 12, 'Offizier'),
(4, 'Tuğgeneral', 'Brigadegeneral', 13, 'General'),
(4, 'Tümgeneral', 'Generalmajor', 14, 'General'),
(4, 'Orgeneral', 'General', 16, 'General');

-- Einheitentypen
INSERT INTO einheit_typ (bezeichnung_tr, bezeichnung_de, hierarchie_stufe, beschreibung) VALUES
('Genelkurmay', 'Generalstab', 1, 'Oberkommando TSK'),
('Kuvvet Komutanlığı', 'Teilstreitkraft-Kommando', 2, 'Heer/Marine/Luftwaffe'),
('Ordu', 'Armee', 3, 'Großverband mehrerer Korps'),
('Kolordu', 'Korps', 4, 'Verband mehrerer Divisionen'),
('Tümen', 'Division', 5, 'Großverband ca. 15.000'),
('Tugay', 'Brigade', 6, 'Verband ca. 3.000–5.000'),
('Alay', 'Regiment', 7, 'Verband ca. 1.000–3.000'),
('Tabur', 'Bataillon', 8, 'Einheit ca. 300–1.000'),
('Bölük', 'Kompanie', 9, 'Einheit ca. 80–250'),
('Takım', 'Zug', 10, 'Gruppe ca. 30–50'),
('Manga', 'Gruppe', 11, 'Kleinste Einheit 8–12');

-- (ALLE Einheiten, Soldaten, Updates, Dienstposten, Views)
-- Dein ursprünglicher Code läuft hier ohne Änderungen weiter.
-- Kopiere ab hier den kompletten Rest deiner Inserts und View-Erstellungen.

-- =====================================================
-- VIEWS
-- =====================================================

-- =====================================================
-- VIEWS
-- =====================================================

DROP VIEW IF EXISTS v_tsk_hierarchie;
DROP VIEW IF EXISTS v_einheiten_baum;
DROP VIEW IF EXISTS v_waffengattungen;

CREATE VIEW v_tsk_hierarchie AS
SELECT 
    s.soldat_id,
    CONCAT(s.vorname, ' ', s.nachname) AS name,
    d.bezeichnung_tr AS dienstgrad_tr,
    d.bezeichnung_de AS dienstgrad_de,
    d.rang_stufe,
    w.bezeichnung AS waffengattung,
    e.name AS einheit,
    et.bezeichnung_de AS einheit_typ,
    et.hierarchie_stufe AS ebene,
    e.standort,
    CONCAT(v.vorname, ' ', v.nachname) AS vorgesetzter
FROM soldat s
JOIN dienstgrad d ON s.dienstgrad_id = d.dienstgrad_id
JOIN waffengattung w ON s.waffengattung_id = w.waffengattung_id
LEFT JOIN einheit e ON s.aktuelle_einheit_id = e.einheit_id
LEFT JOIN einheit_typ et ON e.typ_id = et.typ_id
LEFT JOIN soldat v ON s.direkter_vorgesetzter_id = v.soldat_id
ORDER BY d.rang_stufe DESC;

CREATE VIEW v_einheiten_baum AS
SELECT 
    e.einheit_id,
    e.name,
    w.bezeichnung AS waffengattung,
    et.bezeichnung_de AS typ,
    et.hierarchie_stufe AS ebene,
    e.standort,
    CONCAT(k.vorname, ' ', k.nachname) AS kommandeur,
    dk.bezeichnung_de AS kommandeur_rang,
    ue.name AS uebergeordnete_einheit
FROM einheit e
JOIN waffengattung w ON e.waffengattung_id = w.waffengattung_id
JOIN einheit_typ et ON e.typ_id = et.typ_id
LEFT JOIN soldat k ON e.kommandeur_id = k.soldat_id
LEFT JOIN dienstgrad dk ON k.dienstgrad_id = dk.dienstgrad_id
LEFT JOIN einheit ue ON e.uebergeordnete_einheit_id = ue.einheit_id
ORDER BY et.hierarchie_stufe, e.einheit_id;

CREATE VIEW v_waffengattungen AS
SELECT 
    w.bezeichnung,
    w.abkuerzung,
    COUNT(DISTINCT e.einheit_id) AS anzahl_einheiten,
    COUNT(DISTINCT s.soldat_id) AS anzahl_soldaten,
    ek.name AS kommando_einheit,
    CONCAT(sk.vorname, ' ', sk.nachname) AS kommandeur
FROM waffengattung w
LEFT JOIN einheit e ON w.waffengattung_id = e.waffengattung_id
LEFT JOIN soldat s ON w.waffengattung_id = s.waffengattung_id
LEFT JOIN einheit ek ON w.waffengattung_id = ek.waffengattung_id AND ek.typ_id = 2
LEFT JOIN soldat sk ON ek.kommandeur_id = sk.soldat_id
GROUP BY w.waffengattung_id
ORDER BY w.waffengattung_id;

-- =====================================================
-- TEST-ABFRAGEN
-- =====================================================

SELECT '=== TSK HIERARCHIE ===' AS Info;
SELECT * FROM v_tsk_hierarchie;

SELECT '=== EINHEITEN BAUM ===' AS Info;
SELECT * FROM v_einheiten_baum;

SELECT '=== WAFFENGATTUNGEN ===' AS Info;
SELECT * FROM v_waffengattungen;
