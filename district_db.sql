-- phpMyAdmin SQL Dump
-- version 5.2.1deb3
-- https://www.phpmyadmin.net/
--
-- Hôte : localhost:3306
-- Généré le : mar. 29 avr. 2025 à 11:51
-- Version du serveur : 8.0.41-0ubuntu0.24.04.1
-- Version de PHP : 8.3.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `district_db`
--

-- --------------------------------------------------------

--
-- Structure de la table `aspirants`
--

CREATE TABLE `aspirants` (
  `id` int NOT NULL,
  `user_id` int NOT NULL,
  `parcours` enum('Chef Guide','Senior Youth Leader') NOT NULL,
  `status` enum('en_cours','memoire_soumis','en_attente_investiture','investi') DEFAULT 'en_cours',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `aspirants`
--

INSERT INTO `aspirants` (`id`, `user_id`, `parcours`, `status`, `created_at`) VALUES
(2, 1, 'Chef Guide', 'en_cours', '2025-03-26 07:11:59');

-- --------------------------------------------------------

--
-- Structure de la table `aspirant_requirements`
--

CREATE TABLE `aspirant_requirements` (
  `id` int NOT NULL,
  `aspirant_id` int NOT NULL,
  `requirement_id` int NOT NULL,
  `is_validated` tinyint(1) DEFAULT '0',
  `justification_file` varchar(255) DEFAULT NULL,
  `comment` text,
  `validated_by` int DEFAULT NULL,
  `validated_at` datetime DEFAULT NULL,
  `status` enum('non commencée','en cours','terminée') DEFAULT 'non commencée'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Structure de la table `districts`
--

CREATE TABLE `districts` (
  `id` int NOT NULL,
  `name` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `districts`
--

INSERT INTO `districts` (`id`, `name`) VALUES
(1, 'District Antananarivo'),
(2, 'District Fianarantsoa'),
(3, 'District Toamasina'),
(4, 'District Mahajanga'),
(5, 'District Toliara'),
(6, 'District Antsiranana');

-- --------------------------------------------------------

--
-- Structure de la table `investitures`
--

CREATE TABLE `investitures` (
  `id` int NOT NULL,
  `date` date DEFAULT NULL,
  `location` varchar(255) DEFAULT NULL,
  `region_id` int DEFAULT NULL,
  `notes` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `investitures`
--

INSERT INTO `investitures` (`id`, `date`, `location`, `region_id`, `notes`) VALUES
(1, '2025-05-15', 'Fianarantsoa', 1, 'Cérémonie spéciale pour les jeunes');

-- --------------------------------------------------------

--
-- Structure de la table `investiture_aspirants`
--

CREATE TABLE `investiture_aspirants` (
  `id` int NOT NULL,
  `investiture_id` int DEFAULT NULL,
  `aspirant_id` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Structure de la table `memoires`
--

CREATE TABLE `memoires` (
  `id` int NOT NULL,
  `user_id` int NOT NULL,
  `aspirant_id` int DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `file_path` varchar(255) DEFAULT NULL,
  `is_validated` tinyint(1) DEFAULT '0',
  `validated_by` int DEFAULT NULL,
  `submitted_at` datetime DEFAULT NULL,
  `validated_at` datetime DEFAULT NULL,
  `status` enum('en_attente','valide','refuse') DEFAULT 'en_attente'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `memoires`
--

INSERT INTO `memoires` (`id`, `user_id`, `aspirant_id`, `title`, `file_path`, `is_validated`, `validated_by`, `submitted_at`, `validated_at`, `status`) VALUES
(1, 1, NULL, NULL, 'memoire-1742993743552.png', 1, 14, NULL, '2025-04-24 13:22:59', 'en_attente'),
(2, 1, NULL, NULL, 'memoire-1742993826580.png', 0, NULL, NULL, NULL, 'en_attente'),
(3, 1, NULL, NULL, 'memoire-1742993862633.pdf', 0, NULL, NULL, NULL, 'en_attente'),
(4, 1, NULL, NULL, 'memoire-1744639907318.pdf', 0, NULL, NULL, NULL, 'en_attente');

-- --------------------------------------------------------

--
-- Structure de la table `proofs`
--

CREATE TABLE `proofs` (
  `id` int NOT NULL,
  `user_id` int DEFAULT NULL,
  `requirement_id` int DEFAULT NULL,
  `file_path` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `status` enum('en_attente','valide','refuse') DEFAULT 'en_attente'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `proofs`
--

INSERT INTO `proofs` (`id`, `user_id`, `requirement_id`, `file_path`, `created_at`, `status`) VALUES
(1, 13, 1, 'proof-1742978863092.png', '2025-03-26 08:47:43', 'valide'),
(2, 1, 2, 'proof-1742980027543.png', '2025-03-26 09:07:07', 'valide'),
(3, 1, 1, 'proof-1743351625069.pdf', '2025-03-30 16:20:25', 'valide'),
(4, 1, 1, 'proof-1743351630057.pdf', '2025-03-30 16:20:30', 'valide'),
(5, 1, 1, 'proof-1743351633647.pdf', '2025-03-30 16:20:33', 'valide'),
(6, 1, 1, 'proof-1743351636932.pdf', '2025-03-30 16:20:36', 'valide'),
(7, 1, 1, 'proof-1743351640229.pdf', '2025-03-30 16:20:40', 'refuse'),
(8, 1, 1, 'proof-1744170546497.pdf', '2025-04-09 03:49:06', 'en_attente'),
(9, 1, 1, 'proof-1744639910712.pdf', '2025-04-14 14:11:50', 'en_attente'),
(10, 1, 2, 'proof-1744890496044.pdf', '2025-04-17 11:48:16', 'en_attente');

-- --------------------------------------------------------

--
-- Structure de la table `regions`
--

CREATE TABLE `regions` (
  `id` int NOT NULL,
  `name` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `regions`
--

INSERT INTO `regions` (`id`, `name`) VALUES
(1, 'Alaotra mangoro');

-- --------------------------------------------------------

--
-- Structure de la table `requirements`
--

CREATE TABLE `requirements` (
  `id` int NOT NULL,
  `parcours` varchar(20) DEFAULT NULL,
  `title` varchar(255) NOT NULL,
  `description` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `requirements`
--

INSERT INTO `requirements` (`id`, `parcours`, `title`, `description`) VALUES
(14, 'FTM5', 'FEPETRA TAKIANA MIALOHA', '5. Nahavita ny seminera fiofanana fototra ho an’ny STAFF (BST) ao amin’ny Fiofanana ho amin’ny Asa Fanompoana ny Klioba CMT...'),
(15, 'I-1g', 'I-FITARIHANA & FIVELARANA', '• Fanabeazana: Petra-kevitra & fampiharana'),
(16, 'I-1h', 'I-FITARIHANA & FIVELARANA', '• Loharanon-kevitra ho amin’ny fampianarana tia karokaroka'),
(17, 'I-2', 'I-FITARIHANA & FIVELARANA', 'Mamaky na mihaino ny boky Fanabeazana nosoratan’i Ellen White ary manoratra fisaintsainana pejy iray...'),
(18, 'I-3', 'I-FITARIHANA & FIVELARANA', 'Mamaky na mihaino boky iray mahasika ny fahaiza-mitarika advantista nosafidian’ny Federasiona/Misiona...'),
(19, 'I-4a', 'I-FITARIHANA & FIVELARANA', '• Fanomezam-pahasoavana'),
(20, 'I-4b', 'I-FITARIHANA & FIVELARANA', '• Tamba-toetra (personalités)'),
(21, 'I-5a', 'I-FITARIHANA & FIVELARANA', '• Manatrika 75% amin’ny fivoriana rehetra ataon’ny STAFF'),
(22, 'I-5b', 'I-FITARIHANA & FIVELARANA', '• Manana Mari-pankasitrahana 3 amin’ny Mpisantatra na Asa manavanana 2 amin’ny Mpisavalàlana'),
(23, 'I-5c', 'I-FITARIHANA & FIVELARANA', '• Manana ny Asa Manavanana Fitantarana Tantara Kristiana'),
(24, 'II-4', 'II-FITOMBOANA EO AMIN\'NY FOMBA FIAINANA', 'Manana taratasy Fanamarinana Vonjy aina sy CPR avy any amin’ny Vokovoko mena...'),
(25, 'III-1a', 'III-FITOMBOANA ARA-PANAHY', '• Mamaky na mihaino ny Filazantsara efatra sy ny boky Ilay Fitiavana Mandresy nosoratan’i Ellen White'),
(26, 'III-1b', 'III-FITOMBOANA ARA-PANAHY', '• Mamaky na mihaino ny drafitra Fihaonana, Fizarana voalohany: Kristy no Làlana.'),
(27, 'III-2', 'III-FITOMBOANA ARA-PANAHY', 'Mirakitra an-tsoratra, diary fibanjinana farafahakeliny iray volana...'),
(28, 'III-4', 'III-FITOMBOANA ARA-PANAHY', 'Manoratra paragrafy iray ho fisaintsainana isaky ny tsirairay amin’ny fotopinoana 28.'),
(29, 'IV-1', 'IV-FITOMBOANA EO AMIN\'NY FIARAHA-MONINA', 'Nahazo ny Asa Manavanana Asa fitoriana ataon’ny tena manokana.'),
(30, 'FTM1', 'FEPETRA TAKIANA MIALOHA', '1. Mambra vita batisa sady ara-dalàna ao amin’ny fiangonana Advantista mitandrina ny andro fahafito.'),
(31, 'FTM2', 'FEPETRA TAKIANA MIALOHA', '2. Farafahakeliny 16 taona eo am-panombohana ary 18 taona eo am-pamaranana.'),
(32, 'FTM3', 'FEPETRA TAKIANA MIALOHA', '3. Nahafeno ny fanamarinana fitondran-tena sy ny fiarovana ny ankizy izay nahazoana alàlana avy tamin’ny Federasiona/Misiona.'),
(33, 'FTM4', 'FEPETRA TAKIANA MIALOHA', '4. Mifanakalo hevitra amim-bavaka miaraka amin’ny Mpiahy momba ny dikan’ny hoe Filoha Mpitarika sy antony hitiavanao ho tonga Filoha Mpitarika. Soratana ao anaty takelaka iray ny tatitra ao amin’ny antontan-piraketana. 5. Nahavita ny seminera fototra ho an’ny STAFF (BST) amin’ny Asa Fanompoana ny Klioba CMT na mitovy amin’izany.'),
(34, 'I-1a', 'I-FITARIHANA & FIVELARANA', '• Vina, Iraka, Hery manosika.'),
(35, 'I-1b', 'I-FITARIHANA & FIVELARANA', '• Fitarihana kristiana.'),
(36, 'I-1c', 'I-FITARIHANA & FIVELARANA', '• Fitsipi-pifehezana & Mahampianatra.'),
(37, 'I-1d', 'I-FITARIHANA & FIVELARANA', '• Asa fitoriana amin’ny ankizy sy tanora.'),
(38, 'I-1e', 'I-FITARIHANA & FIVELARANA', '• Mamorona fanompoam-pivavahana mahomby.'),
(39, 'I-1f', 'I-FITARIHANA & FIVELARANA', '• Fifandraisana: Petra-kevitra & Fampiharana.'),
(40, 'I-1g', 'I-FITARIHANA & FIVELARANA', '• Fanabeazana: Petra-kevitra & Fampiharana.'),
(41, 'I-1h', 'I-FITARIHANA & FIVELARANA', '• Loharanon-kevitra ho amin’ny fampianarana tia karokaroka.'),
(42, 'I-2', 'I-FITARIHANA & FIVELARANA', 'Mamaky na mihaino ny boky Fanabeazana nosoratan’i Ellen White ary manoratra fisaintsainana pejy iray mahakasika izay nianarana sy ny fomba hampiharana izany amin’ny asa fanompoana.'),
(43, 'I-3', 'I-FITARIHANA & FIVELARANA', 'Mamaky na mihaino boky iray mahasika ny fahaiza-mitarika advantista nosafidian’ny Federasiona/Misiona ary manao anankiroa amin’ireo safidy ao amin’ny Sehatry ny Fizarana.'),
(44, 'I-4a', 'I-FITARIHANA & FIVELARANA', '• Fanomezam-pahasoavana.'),
(45, 'I-4b', 'I-FITARIHANA & FIVELARANA', '• Tamba-toetra (personalités).'),
(46, 'I-5a', 'I-FITARIHANA & FIVELARANA', '• Manatrika 75% amin’ny fivoriana rehetra ataon’ny STAFF.'),
(47, 'I-5b', 'I-FITARIHANA & FIVELARANA', '• Manana Mari-pankasitrahana 3 amin’ny Mpisantatra na Asa manavanana 2 amin’ny Mpisavalàlana.'),
(48, 'I-5c', 'I-FITARIHANA & FIVELARANA', '• Manana ny Asa Manavanana Fitantarana Tantara Kristiana.'),
(49, 'II-1', 'II-FITOMBOANA EO AMIN\'NY FOMBA FIAINANA', '1. Misafidy ny iray amin’ireto manaraka ireto ary mirakitra ny fandrosoanao :\n- Nahazo ny asa manavanana tomady ara-batana.\n- Nahazo ny mari-pankasitrahana Mpanao Spaoro.\n- Nahavita ny fizarana tomady ara-batana ao amin’ny mari-pankasitrahana volafotsy sy volamena.\n- Misafidy fanazarana ara-batana rehefa nifanakalo hevitra tamin’ny Filoha Mpitarika mpiahy ary nahavita programa 3 volana amin’ny fanatanjahan-tena.\n- Mahavita programa fanatanjahan-tena nomen’ny dokotera mandritra ny telovolana.'),
(50, 'II-2', 'II-FITOMBOANA EO AMIN\'NY FOMBA FIAINANA', '2. Mahazo ireto asa manavanana tsirairay avy ireto :\n- Aro loza amin’ny rano\n- Aro loza amin’ny lasy\n- Fahaiza-manao momba ny lasy I\n- Fahaiza-manao momba ny lasy II\n- Fahalalana onon'),
(51, 'II-3', 'II-FITOMBOANA EO AMIN\'NY FOMBA FIAINANA', '3. Mahazo farafahakeliny telo amin’ireto Asa manavanana ireto :\n- Dia an-tongotra lavitra\n- Vonjy voina fototra\n- Fahaiza-manao momba ny lasy III\n- Fahaiza-manao momba ny lasy IV\n- Fihetsika mirindra & famindrana (drill)\n- Ekolojia\n- Fandrehetana afo & fandrahoana an-dasy\n- Fanaovana vona\n- Fahaizana misakafo (Nutrition)\n- Lalan-kombana (Orientation)\n- Fitantanam-piainana'),
(52, 'II-4', 'II-FITOMBOANA EO AMIN\'NY FOMBA FIAINANA', '4. Manana taratasy Fanamarinana Vonjy aina sy CPR (fameloman’aina) avy any amin’ny Vokovoko mena na ny mitovy amin’izany.'),
(53, 'III-1', 'III-FITOMBOANA ARA-PANAHY', '1. Misafidy ny iray amin’ireto manaraka ireto ary manao ny safidy roa ao amin’ny Sehatry ny Fizarana:\n- Mamaky na mihaino ny Filazantsara efatra sy ny boky Ilay Fitiavana Mandresy nosoratan’i Ellen White\n- Mamaky na mihaino ny drafitra Fihaonana, Fizarana voalohany: Kristy no Làlana.'),
(54, 'III-2', 'III-FITOMBOANA ARA-PANAHY', '2. Mirakitra an-tsoratra, diary fibanjinana farafahakeliny iray volana, mamintina izay nianaranao nandritra ny fotoana fibanjinana ary manoritsoritra ny fomba nitomboanao tamin’ny finoanao.'),
(55, 'III-3', 'III-FITOMBOANA ARA-PANAHY', '3. Mamaky na mihaino ny boky Ny Dia ho eo amin’i Kristy nosoratan’i Ellen White ary manao safidy roa ao amin’ny Sehatry ny Fizarana.'),
(56, 'III-4', 'III-FITOMBOANA ARA-PANAHY', '4. Manoratra paragrafy iray ho fisaintsainana isaky ny tsirairay amin’ny foto-pinoana 28.'),
(57, 'III-5', 'III-FITOMBOANA ARA-PANAHY', '5. Misafidy ny iray amin’ireto manaraka ireto:\n- Mampianatra Baiboly na mampianatra kilasin’ny batisa mandritra ny telovolana\n- Mampianatra ny dimy amin’ireto foto-pinoana ireto amin’ny fandaharana nankatoavin’ny fiangonana:\n  a. Famoronana\n  b. Fanandraman’ny famonjena\n  c. Mitombo ao amin’i Kristy\n  d. Ny sisa sy ny iraka nampanaovina azy\n  e. Batisa\n  f. Fanomezam-pahasoavana sy ny asa fanompoana\n  g. Ny Sabata\n  h. Asa fanompoan’i Kristy ao amin’ny fitoerana masina any an-danitra\n  i. Ny fiavian’i Kristy fanindroany\n  j. Ny fahafatesana sy ny fitsanganana amin’ny mat.'),
(58, 'III-6', 'III-FITOMBOANA ARA-PANAHY', '6. Misafidy ny iray amin’ireto manaraka ireto ary manao ny safidy roa ao amin’ny Sehatry ny Fizarana:\n- Mahazo ny Asa manavanana Fitoerana Masina\n- Manatrika seminera nankatoavin’ny Federasiona mahakasika ny Fitoerana masina.'),
(59, 'III-7', 'III-FITOMBOANA ARA-PANAHY', '7. Misafidy ny iray amin’ireto manaraka ireto ary manao ny safidy roa ao amin’ny Sehatry ny Fizarana:\n- Manana na mahazo ny asa manavanana Lovan’ireo mpamaky lay Advantista.\n- Nijery ny andian-tsary mihetsika “Tell the World”\n- Mijery ny andian-tsary mihetsika “Keepers of the Flame”\n- Mamaky na mihaino boky anankiray mahasika ny lovan’ny Fiangonana izay nankatoavin’ny Federasiona/Misiona.'),
(60, 'IV-1', 'IV-FITOMBOANA EO AMIN\'NY FIARAHA-MONINA', '1. Nahazo ny Asa Manavanana Asa fitoriana ataon’ny tena manokana.'),
(61, 'IV-2', 'IV-FITOMBOANA EO AMIN\'NY FIARAHA-MONINA', '2. Nahazo ny telo amin’ireto asa manavanana manaraka ireto:\n- Fankasitrahana ny fahasamihafana arakolontsaina\n- Mpampihavana\n- Tambajotra sosialy\n- Asa manavanana ADRA iray izay mbola tsy azo tany aloha\n- Asa manavanana iray momba ny fikarakarana tokantrano izay mbola tsy azo tany aloha.'),
(62, 'IV-3', 'IV-FITOMBOANA EO AMIN\'NY FIARAHA-MONINA', '3. Mandray anjara amin’ny fandaminana hetsika ara-tsosialy telo miaraka amin’ny fiangonana eo an-toerana.'),
(63, 'IV-4', 'IV-FITOMBOANA EO AMIN\'NY FIARAHA-MONINA', '4. Misafidy ny iray amin’ireto manaraka ireto ary ampandraiso anjara raha azo atao ny kliobanao na vondrona tanora:\n- Mihaona amin’ny sampan’asan’ny governemanta eo an-toerana na fikambanana hafa ary mandray anjara amin’ny tetik’asa fanompoana ny fiaraha-monina.\n- Miara-miasa amin’ny hetsika fanatrarana ny fiaraha-monina atao amin’ny ADRA eo an-toerana (na ny asa fanompoana mitovy amin’izany) mandritra ny telovolana farafahakeliny.');

-- --------------------------------------------------------

--
-- Structure de la table `users`
--

CREATE TABLE `users` (
  `id` int NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('aspirant','coordinateur_district','coordinateur_region','admin') NOT NULL,
  `district_id` int DEFAULT NULL,
  `region_id` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `is_verified` tinyint(1) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `password`, `role`, `district_id`, `region_id`, `created_at`, `is_verified`) VALUES
(1, 'Jean Aspirant', 'rasoamahazomanana01@gmail.com', '$2b$10$Rxm.PIZY.GcKWpEfTjSvEOWhy5MBrzrTxpewVkZ8a9HRDbmeb3yDe', 'aspirant', 2, 1, '2025-03-25 18:11:25', 1),
(13, 'Jean Coordinateur', 'rogellatsito@yopmail.com', '$2b$10$ZumEwG1uHMp8Fqxo0Dr70uhOQHdHPF.dDnP.49XQKhHRlL4700Fji', 'coordinateur_district', 2, 1, '2025-03-27 17:19:58', 1),
(14, 'Marie Coordinateur', 'rogellaregion@yopmail.com', '$2b$10$BJplbLJwUKxzT1pkyVkafe126146.K1skIrGmAM8L.d.2WZm5ynLK', 'coordinateur_region', NULL, 1, '2025-03-31 02:11:43', 1),
(15, 'user', 'user1@yopmail.com', '$2b$10$5FpMUg.rugDg3y/HOSb4.ucTuQNQcNJp0F/YJIZ2uZS7Y8z0ObMJO', 'aspirant', 2, 1, '2025-03-31 02:21:44', 1),
(16, 'user', 'user2@yopmail.com', '$2b$10$b.pG/GD7TPExirm1de/4JOcnfCLDvSS/nGeowYuemAC0SQ/zeeaFy', 'aspirant', 2, 1, '2025-03-31 02:22:02', 1),
(17, 'user', 'user3@yopmail.com', '$2b$10$LOdXrWMLdFR5YbjCMKxY.eLGsu8g8Ua.NwdUpTK1swHPXoatddqMS', 'aspirant', 2, 1, '2025-03-31 02:22:16', 1),
(18, 'user', 'useradmin@yopmail.com', '$2b$10$KsZtEqlYtnnTaBKDylsVvOmXnh9h4zcJ7kqZLOcbcK8by7qp5yfk.', 'admin', 2, 1, '2025-04-03 08:59:24', 1);

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `aspirants`
--
ALTER TABLE `aspirants`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Index pour la table `aspirant_requirements`
--
ALTER TABLE `aspirant_requirements`
  ADD PRIMARY KEY (`id`),
  ADD KEY `aspirant_id` (`aspirant_id`),
  ADD KEY `requirement_id` (`requirement_id`),
  ADD KEY `validated_by` (`validated_by`);

--
-- Index pour la table `districts`
--
ALTER TABLE `districts`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `investitures`
--
ALTER TABLE `investitures`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `investiture_aspirants`
--
ALTER TABLE `investiture_aspirants`
  ADD PRIMARY KEY (`id`),
  ADD KEY `investiture_id` (`investiture_id`),
  ADD KEY `aspirant_id` (`aspirant_id`);

--
-- Index pour la table `memoires`
--
ALTER TABLE `memoires`
  ADD PRIMARY KEY (`id`),
  ADD KEY `aspirant_id` (`aspirant_id`),
  ADD KEY `validated_by` (`validated_by`);

--
-- Index pour la table `proofs`
--
ALTER TABLE `proofs`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `regions`
--
ALTER TABLE `regions`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `requirements`
--
ALTER TABLE `requirements`
  ADD PRIMARY KEY (`id`);

--
-- Index pour la table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `aspirants`
--
ALTER TABLE `aspirants`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT pour la table `aspirant_requirements`
--
ALTER TABLE `aspirant_requirements`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT pour la table `districts`
--
ALTER TABLE `districts`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT pour la table `investitures`
--
ALTER TABLE `investitures`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `investiture_aspirants`
--
ALTER TABLE `investiture_aspirants`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `memoires`
--
ALTER TABLE `memoires`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT pour la table `proofs`
--
ALTER TABLE `proofs`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT pour la table `regions`
--
ALTER TABLE `regions`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT pour la table `requirements`
--
ALTER TABLE `requirements`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=64;

--
-- AUTO_INCREMENT pour la table `users`
--
ALTER TABLE `users`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `aspirants`
--
ALTER TABLE `aspirants`
  ADD CONSTRAINT `aspirants_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Contraintes pour la table `aspirant_requirements`
--
ALTER TABLE `aspirant_requirements`
  ADD CONSTRAINT `aspirant_requirements_ibfk_1` FOREIGN KEY (`aspirant_id`) REFERENCES `aspirants` (`id`),
  ADD CONSTRAINT `aspirant_requirements_ibfk_2` FOREIGN KEY (`requirement_id`) REFERENCES `requirements` (`id`),
  ADD CONSTRAINT `aspirant_requirements_ibfk_3` FOREIGN KEY (`validated_by`) REFERENCES `users` (`id`);

--
-- Contraintes pour la table `investiture_aspirants`
--
ALTER TABLE `investiture_aspirants`
  ADD CONSTRAINT `investiture_aspirants_ibfk_1` FOREIGN KEY (`investiture_id`) REFERENCES `investitures` (`id`),
  ADD CONSTRAINT `investiture_aspirants_ibfk_2` FOREIGN KEY (`aspirant_id`) REFERENCES `aspirants` (`id`);

--
-- Contraintes pour la table `memoires`
--
ALTER TABLE `memoires`
  ADD CONSTRAINT `memoires_ibfk_1` FOREIGN KEY (`aspirant_id`) REFERENCES `aspirants` (`id`),
  ADD CONSTRAINT `memoires_ibfk_2` FOREIGN KEY (`validated_by`) REFERENCES `users` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
