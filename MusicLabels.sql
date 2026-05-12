-- ============================================================
--  ГРАФОВАЯ БАЗА ДАННЫХ: Музыкальные лейблы
-- ============================================================

USE master;
GO
IF DB_ID('MusicLabelsDB') IS NOT NULL DROP DATABASE MusicLabelsDB;
GO
CREATE DATABASE MusicLabelsDB;
GO
USE MusicLabelsDB;
GO

-- ============================================================
-- РАЗДЕЛ 1: ТАБЛИЦЫ УЗЛОВ
-- ============================================================

CREATE TABLE Artists (
    ArtistID  INT NOT NULL, StageName NVARCHAR(100) NOT NULL,
    RealName  NVARCHAR(150), BirthYear INT,
    Country   NVARCHAR(60),  Genre     NVARCHAR(60),
    IsActive  BIT NOT NULL DEFAULT 1
) AS NODE;
GO

CREATE TABLE Producers (
    ProducerID INT NOT NULL, FullName  NVARCHAR(150) NOT NULL,
    BirthYear  INT,          Country   NVARCHAR(60),
    Specialty  NVARCHAR(100)
) AS NODE;
GO

CREATE TABLE Labels (
    LabelID     INT NOT NULL,  LabelName   NVARCHAR(150) NOT NULL,
    Founded     INT,           Country     NVARCHAR(60),
    ParentLabel NVARCHAR(150), Revenue_M   DECIMAL(10,2)
) AS NODE;
GO

CREATE TABLE Albums (
    AlbumID     INT NOT NULL,  Title       NVARCHAR(200) NOT NULL,
    ReleaseYear INT,           Genre       NVARCHAR(60),
    SalesM      DECIMAL(8,2), Award       NVARCHAR(100)
) AS NODE;
GO

CREATE TABLE Genres (
    GenreID     INT NOT NULL,  GenreName   NVARCHAR(80) NOT NULL,
    Description NVARCHAR(300)
) AS NODE;
GO

-- ============================================================
-- РАЗДЕЛ 2: ТАБЛИЦЫ РЁБЕР С CONNECTION CONSTRAINT
-- ============================================================

CREATE TABLE SignedWith (
    ContractDate DATE, ContractYears INT,
    AdvanceUSD_K DECIMAL(10,2), RoyaltyPct DECIMAL(5,2),
    Status NVARCHAR(30),
    CONSTRAINT EC_SignedWith CONNECTION (Artists TO Labels)
) AS EDGE;
GO

CREATE TABLE ProducedAlbum (
    RoleDescription NVARCHAR(100),
    StartDate DATE, EndDate DATE, FeeUSD_K DECIMAL(10,2),
    CONSTRAINT EC_ProducedAlbum CONNECTION (Producers TO Albums)
) AS EDGE;
GO

CREATE TABLE Released (
    ReleaseDate DATE, LabelAtRelease NVARCHAR(150), IsLead BIT DEFAULT 1,
    CONSTRAINT EC_Released CONNECTION (Artists TO Albums)
) AS EDGE;
GO

CREATE TABLE Collaborates (
    SinceYear INT, ProjectCount INT, Exclusive BIT DEFAULT 0,
    CONSTRAINT EC_Collaborates CONNECTION (Producers TO Artists)
) AS EDGE;
GO

CREATE TABLE BelongsToGenre (
    IsPrimary BIT DEFAULT 1, InfluencePct INT,
    CONSTRAINT EC_BelongsToGenre CONNECTION (Albums TO Genres)
) AS EDGE;
GO

CREATE TABLE OwnsRights (
    AcquisitionYear INT, StakePct DECIMAL(5,2),
    DealValueM DECIMAL(10,2), RightsType NVARCHAR(50),
    CONSTRAINT EC_OwnsRights CONNECTION (Labels TO Labels)
) AS EDGE;
GO

-- ============================================================
-- РАЗДЕЛ 3: ЗАПОЛНЕНИЕ УЗЛОВ
-- Не указываем $node_id — проставляется автоматически
-- ============================================================

INSERT INTO Genres (GenreID, GenreName, Description) VALUES
(1, N'Pop',        N'Коммерческая поп-музыка широкого охвата'),
(2, N'Hip-Hop',    N'Рэп, битмейкинг, культура улиц'),
(3, N'R&B',        N'Ритм-энд-блюз, соул, фанк'),
(4, N'Rock',       N'Гитарная музыка, от классики до хард-рока'),
(5, N'Electronic', N'EDM, хаус, техно, синти-поп'),
(6, N'Jazz',       N'Импровизационная музыка, стандарты'),
(7, N'Country',    N'Американская кантри и фолк'),
(8, N'Latin',      N'Reggaeton, salsa, bachata, latin pop'),
(9, N'K-Pop',      N'Корейская поп-музыка'),
(10,N'Classical',  N'Академическая и оркестровая музыка'),
(11,N'Indie',      N'Независимая альтернативная музыка'),
(12,N'Metal',      N'Тяжёлый металл и его субжанры');
GO

INSERT INTO Labels (LabelID, LabelName, Founded, Country, ParentLabel, Revenue_M) VALUES
(1, N'Universal Music Group',    1934, N'USA',         NULL,                        10000.00),
(2, N'Sony Music Entertainment', 1929, N'USA',         NULL,                         8500.00),
(3, N'Warner Music Group',       1958, N'USA',         NULL,                         5600.00),
(4, N'Def Jam Recordings',       1983, N'USA',         N'Universal Music Group',      950.00),
(5, N'Republic Records',         1995, N'USA',         N'Universal Music Group',     1200.00),
(6, N'Atlantic Records',         1947, N'USA',         N'Warner Music Group',         870.00),
(7, N'Columbia Records',         1887, N'USA',         N'Sony Music Entertainment',   980.00),
(8, N'Interscope Records',       1990, N'USA',         N'Universal Music Group',      760.00),
(9, N'HYBE Labels',              2005, N'South Korea', NULL,                         1100.00),
(10,N'XL Recordings',            1989, N'UK',          N'Warner Music Group',          210.00),
(11,N'Motown Records',           1959, N'USA',         N'Universal Music Group',       180.00),
(12,N'Sub Pop Records',          1986, N'USA',         NULL,                            55.00);
GO

INSERT INTO Producers (ProducerID, FullName, BirthYear, Country, Specialty) VALUES
(1, N'Max Martin',        1971, N'Sweden', N'Pop songwriting & production'),
(2, N'Quincy Jones',      1933, N'USA',    N'Jazz, R&B, orchestral'),
(3, N'Rick Rubin',        1963, N'USA',    N'Rock, Hip-Hop, crossover'),
(4, N'Dr. Dre',           1965, N'USA',    N'West Coast Hip-Hop'),
(5, N'Pharrell Williams', 1973, N'USA',    N'Neo-Soul, Pop, Hip-Hop'),
(6, N'Timbaland',         1972, N'USA',    N'R&B, Pop, electronic beats'),
(7, N'Brian Eno',         1948, N'UK',     N'Ambient, Art Rock, synthesis'),
(8, N'Metro Boomin',      1993, N'USA',    N'Trap, Hip-Hop'),
(9, N'Jack Antonoff',     1984, N'USA',    N'Indie Pop, Alt Rock'),
(10,N'Calvin Harris',     1984, N'UK',     N'EDM, House, Pop'),
(11,N'Finneas OConnell',  1997, N'USA',    N'Bedroom Pop, electronic'),
(12,N'Danger Mouse',      1977, N'USA',    N'Indie, Hip-Hop, eclectic');
GO

INSERT INTO Artists (ArtistID, StageName, RealName, BirthYear, Country, Genre, IsActive) VALUES
(1, N'Taylor Swift',   N'Taylor Alison Swift',        1989, N'USA',         N'Pop/Country', 1),
(2, N'Drake',          N'Aubrey Drake Graham',         1986, N'Canada',      N'Hip-Hop/R&B', 1),
(3, N'Billie Eilish',  N'Billie Eilish OConnell',      2001, N'USA',         N'Pop',         1),
(4, N'Kendrick Lamar', N'Kendrick Lamar Duckworth',    1987, N'USA',         N'Hip-Hop',     1),
(5, N'Adele',          N'Adele Laurie Blue Adkins',    1988, N'UK',          N'Soul/Pop',    1),
(6, N'The Weeknd',     N'Abel Makkonen Tesfaye',       1990, N'Canada',      N'R&B/Pop',     1),
(7, N'BTS',            N'Bangtan Sonyeondan',           2013, N'South Korea', N'K-Pop',       1),
(8, N'Eminem',         N'Marshall Bruce Mathers III',  1972, N'USA',         N'Hip-Hop',     1),
(9, N'Beyonce',        N'Beyonce Giselle Knowles',     1981, N'USA',         N'R&B/Pop',     1),
(10,N'Ed Sheeran',     N'Edward Christopher Sheeran',  1991, N'UK',          N'Pop/Folk',    1),
(11,N'Bad Bunny',      N'Benito Antonio Martinez',     1994, N'Puerto Rico', N'Latin',       1),
(12,N'Radiohead',      N'Radiohead',                   1985, N'UK',          N'Indie/Rock',  1);
GO

INSERT INTO Albums (AlbumID, Title, ReleaseYear, Genre, SalesM, Award) VALUES
(1, N'1989',                    2014, N'Pop',       10.10, N'Grammy: Album of the Year'),
(2, N'Scorpion',                2018, N'Hip-Hop',    3.00, NULL),
(3, N'When We All Fall Asleep', 2019, N'Pop',         5.00, N'Grammy: Album of the Year'),
(4, N'To Pimp a Butterfly',    2015, N'Hip-Hop',    1.50, N'Grammy: Best Rap Album'),
(5, N'21',                      2011, N'Soul',       31.00, N'Grammy: Album of the Year'),
(6, N'After Hours',             2020, N'R&B',         3.20, NULL),
(7, N'Map of the Soul 7',       2020, N'K-Pop',       4.38, NULL),
(8, N'The Marshall Mathers LP', 2000, N'Hip-Hop',   21.00, N'Grammy: Best Rap Album'),
(9, N'Lemonade',                2016, N'R&B',         2.50, N'Grammy: Best Urban Contemporary'),
(10,N'Divide',                  2017, N'Pop',        16.00, NULL),
(11,N'Un Verano Sin Ti',        2022, N'Latin',       1.80, N'Grammy: Best Musica Urbana'),
(12,N'OK Computer',             1997, N'Indie Rock',  4.50, N'Grammy: Best Alternative Album'),
(13,N'Midnights',               2022, N'Pop',         6.50, N'Grammy: Album of the Year'),
(14,N'Her Loss',                2022, N'Hip-Hop',    1.20, NULL),
(15,N'Happier Than Ever',       2021, N'Pop',         2.10, N'Grammy: Best Pop Vocal Album');
GO

-- ============================================================
-- РАЗДЕЛ 4: ЗАПОЛНЕНИЕ РЁБЕР
-- ============================================================

INSERT INTO SignedWith ($from_id, $to_id, ContractDate, ContractYears, AdvanceUSD_K, RoyaltyPct, Status)
SELECT a.$node_id, l.$node_id, v.ContractDate, v.ContractYears, v.AdvanceUSD_K, v.RoyaltyPct, v.Status
FROM (VALUES
    (1,  5,  '2018-11-19', 5, 7000.00, 18.00, N'Active'),
    (2,  6,  '2009-06-01', 6,  500.00, 22.00, N'Active'),
    (3,  8,  '2016-11-16', 7, 1000.00, 15.00, N'Active'),
    (4,  4,  '2012-01-01', 8,  300.00, 20.00, N'Active'),
    (5,  7,  '2007-09-21', 6, 1500.00, 17.00, N'Active'),
    (6,  5,  '2012-08-28', 7,  800.00, 21.00, N'Active'),
    (7,  9,  '2017-02-26', 7, 2000.00, 12.00, N'Active'),
    (8,  5,  '1999-02-22', 8, 1000.00, 19.00, N'Active'),
    (9,  1,  '2016-04-23', 5, 3000.00, 20.00, N'Active'),
    (10, 6,  '2011-01-01', 6,  600.00, 16.00, N'Active'),
    (11, 2,  '2018-03-01', 6,  400.00, 22.00, N'Active'),
    (12, 10, '1993-01-01', 10,  50.00, 14.00, N'Expired')
) AS v(ArtistID, LabelID, ContractDate, ContractYears, AdvanceUSD_K, RoyaltyPct, Status)
JOIN Artists a ON a.ArtistID = v.ArtistID
JOIN Labels  l ON l.LabelID  = v.LabelID;
GO

INSERT INTO Released ($from_id, $to_id, ReleaseDate, LabelAtRelease, IsLead)
SELECT a.$node_id, al.$node_id, v.ReleaseDate, v.LabelAtRelease, v.IsLead
FROM (VALUES
    (1,  1,  '2014-10-27', N'Republic Records',     1),
    (1,  13, '2022-10-21', N'Republic Records',     1),
    (2,  2,  '2018-06-29', N'Young Money',           1),
    (2,  14, '2022-11-04', N'Republic Records',     1),
    (3,  3,  '2019-03-29', N'Interscope Records',   1),
    (3,  15, '2021-07-30', N'Interscope Records',   1),
    (4,  4,  '2015-03-15', N'Top Dawg/Interscope',  1),
    (5,  5,  '2011-01-24', N'Columbia Records',     1),
    (6,  6,  '2020-03-20', N'Republic Records',     1),
    (7,  7,  '2020-02-21', N'HYBE Labels',           1),
    (8,  8,  '2000-05-23', N'Aftermath/Interscope', 1),
    (9,  9,  '2016-04-23', N'Parkwood/Columbia',    1),
    (10, 10, '2017-03-03', N'Atlantic Records',     1),
    (11, 11, '2022-05-06', N'Rimas Entertainment',  1),
    (12, 12, '1997-05-21', N'Parlophone/Capitol',   1)
) AS v(ArtistID, AlbumID, ReleaseDate, LabelAtRelease, IsLead)
JOIN Artists a  ON a.ArtistID = v.ArtistID
JOIN Albums  al ON al.AlbumID = v.AlbumID;
GO

INSERT INTO ProducedAlbum ($from_id, $to_id, RoleDescription, StartDate, EndDate, FeeUSD_K)
SELECT p.$node_id, al.$node_id, v.RoleDescription, v.StartDate, v.EndDate, v.FeeUSD_K
FROM (VALUES
    (1,  1,  N'Executive Producer',     '2013-01-01', '2014-09-01',  500.00),
    (1,  13, N'Co-Producer',            '2022-01-01', '2022-08-01',  400.00),
    (11, 3,  N'Executive Producer',     '2018-01-01', '2019-02-01',  200.00),
    (11, 15, N'Executive Producer',     '2020-06-01', '2021-06-01',  250.00),
    (9,  3,  N'Co-Producer',            '2018-06-01', '2019-02-01',  150.00),
    (4,  8,  N'Executive Producer',     '1999-01-01', '2000-03-01',  800.00),
    (4,  4,  N'Executive Producer',     '2014-01-01', '2015-02-01',  600.00),
    (3,  8,  N'A&R / Producer',         '1999-01-01', '2000-04-01',  700.00),
    (5,  9,  N'Co-Producer',            '2015-10-01', '2016-03-01',  900.00),
    (6,  2,  N'Collaborating Producer', '2017-09-01', '2018-05-01',  350.00),
    (2,  5,  N'Orchestral arranger',    '2010-06-01', '2011-01-01', 1200.00),
    (7,  12, N'Sound Design',           '1996-01-01', '1997-04-01',  120.00),
    (10, 6,  N'Featured Production',    '2019-06-01', '2020-01-01',  400.00),
    (8,  7,  N'K-Pop Production Collab','2019-09-01', '2020-01-01',  300.00),
    (12, 4,  N'Contributing Producer',  '2014-03-01', '2015-01-01',  200.00)
) AS v(ProducerID, AlbumID, RoleDescription, StartDate, EndDate, FeeUSD_K)
JOIN Producers p  ON p.ProducerID = v.ProducerID
JOIN Albums    al ON al.AlbumID   = v.AlbumID;
GO

INSERT INTO Collaborates ($from_id, $to_id, SinceYear, ProjectCount, Exclusive)
SELECT p.$node_id, a.$node_id, v.SinceYear, v.ProjectCount, v.Exclusive
FROM (VALUES
    (1,  1,  2012, 7, 0), (1,  6,  2015, 4, 0),
    (11, 3,  2016, 5, 1), (9,  3,  2018, 3, 0),
    (9,  1,  2017, 6, 0), (4,  8,  1999, 8, 0),
    (4,  4,  2012, 5, 0), (5,  9,  2013, 6, 0),
    (5,  10, 2014, 3, 0), (6,  2,  2016, 7, 0),
    (8,  2,  2017, 9, 0), (10, 6,  2019, 4, 0),
    (3,  8,  1999, 6, 0), (7,  12, 1996, 5, 0),
    (12, 4,  2014, 4, 0)
) AS v(ProducerID, ArtistID, SinceYear, ProjectCount, Exclusive)
JOIN Producers p ON p.ProducerID = v.ProducerID
JOIN Artists   a ON a.ArtistID   = v.ArtistID;
GO

INSERT INTO BelongsToGenre ($from_id, $to_id, IsPrimary, InfluencePct)
SELECT al.$node_id, g.$node_id, v.IsPrimary, v.InfluencePct
FROM (VALUES
    (1,  1,  1, 90), (1,  7,  0, 10),
    (2,  2,  1, 80), (2,  3,  0, 20),
    (3,  1,  1, 70), (3,  5,  0, 30),
    (4,  2,  1, 85), (4,  3,  0, 15),
    (5,  3,  1, 60), (5,  1,  0, 40),
    (6,  3,  1, 70), (6,  1,  0, 30),
    (7,  9,  1, 95), (8,  2,  1, 95),
    (9,  3,  1, 60), (9,  1,  0, 40),
    (10, 1,  1, 80), (10, 11, 0, 20),
    (11, 8,  1, 90),
    (12, 11, 1, 60), (12, 4,  0, 40),
    (13, 1,  1, 85), (13, 11, 0, 15),
    (14, 2,  1, 75), (14, 3,  0, 25),
    (15, 1,  1, 80), (15, 11, 0, 20)
) AS v(AlbumID, GenreID, IsPrimary, InfluencePct)
JOIN Albums al ON al.AlbumID = v.AlbumID
JOIN Genres g  ON g.GenreID  = v.GenreID;
GO

INSERT INTO OwnsRights ($from_id, $to_id, AcquisitionYear, StakePct, DealValueM, RightsType)
SELECT l1.$node_id, l2.$node_id, v.AcquisitionYear, v.StakePct, v.DealValueM, v.RightsType
FROM (VALUES
    (1, 4,  1999, 100.00,  600.00,   N'Full'),
    (1, 5,  2012, 100.00,    NULL,   N'Full'),
    (1, 8,  1999, 100.00, 3100.00,   N'Full'),
    (1, 11, 1988, 100.00,   61.00,   N'Full'),
    (2, 7,  1988, 100.00,    NULL,   N'Full'),
    (3, 6,  1967, 100.00,    NULL,   N'Full'),
    (3, 10, 2012,  75.00,  200.00,   N'Partial'),
    (1, 3,  2021,  10.00, 12300.00,  N'Partial'),
    (4, 5,  2000,   0.00,    0.00,   N'Distribution'),
    (9, 4,  2021,  49.00, 1000.00,   N'Partial')
) AS v(LabelID1, LabelID2, AcquisitionYear, StakePct, DealValueM, RightsType)
JOIN Labels l1 ON l1.LabelID = v.LabelID1
JOIN Labels l2 ON l2.LabelID = v.LabelID2;
GO

-- ============================================================
-- РАЗДЕЛ 5: ЗАПРОСЫ С MATCH
-- ============================================================

-- ЗАПРОС 1: Артисты с активными контрактами
SELECT
    a.StageName AS Артист, a.Country AS Страна,
    l.LabelName AS Лейбл,  sw.ContractDate AS ДатаКонтракта,
    sw.RoyaltyPct AS РоялтиПроц, sw.Status AS Статус
FROM Artists AS a, SignedWith AS sw, Labels AS l
WHERE MATCH(a-(sw)->l) AND sw.Status = N'Active'
ORDER BY l.LabelName, a.StageName;
GO

-- ЗАПРОС 2: Трёхзвенная цепочка: Продюсер -> Артист -> Лейбл
SELECT
    p.FullName AS Продюсер, a.StageName AS Артист,
    l.LabelName AS Лейбл,  c.SinceYear AS СотрудничествоС,
    c.ProjectCount AS Проекты, sw.RoyaltyPct AS РоялтиАртиста
FROM Producers AS p, Collaborates AS c, Artists AS a,
     SignedWith AS sw, Labels AS l
WHERE MATCH(p-(c)->a-(sw)->l)
ORDER BY p.FullName, a.StageName;
GO

-- ЗАПРОС 3: Четырёхзвенная цепочка: Продюсер -> Альбом -> Жанр + Артист -> Альбом
SELECT DISTINCT
    p.FullName AS Продюсер,  a.StageName AS Артист,
    al.Title AS Альбом,      g.GenreName AS Жанр,
    btg.InfluencePct AS ДоляЖанра
FROM Producers AS p, ProducedAlbum AS pa, Albums AS al,
     BelongsToGenre AS btg, Genres AS g,
     Released AS r, Artists AS a
WHERE MATCH(p-(pa)->al-(btg)->g) AND MATCH(a-(r)->al)
ORDER BY p.FullName, g.GenreName;
GO

-- ЗАПРОС 4: Альбомы артистов Republic Records с жанром
SELECT
    l.LabelName AS Лейбл,  a.StageName AS Артист,
    al.Title AS Альбом,    al.ReleaseYear AS Год,
    g.GenreName AS Жанр,   al.SalesM AS ПродажиМлн
FROM Labels AS l, SignedWith AS sw, Artists AS a,
     Released AS r, Albums AS al, BelongsToGenre AS btg, Genres AS g
WHERE MATCH(a-(sw)->l) AND MATCH(a-(r)->al-(btg)->g)
  AND l.LabelName = N'Republic Records' AND btg.IsPrimary = 1
ORDER BY al.ReleaseYear DESC;
GO

-- ЗАПРОС 5: Пары продюсеров на одном альбоме
SELECT
    p1.FullName AS Продюсер1,          p2.FullName AS Продюсер2,
    al.Title AS Альбом,                al.ReleaseYear AS Год,
    pa1.RoleDescription AS РольПрод1,  pa2.RoleDescription AS РольПрод2
FROM Producers AS p1, ProducedAlbum AS pa1, Albums AS al,
     ProducedAlbum AS pa2, Producers AS p2
WHERE MATCH(p1-(pa1)->al<-(pa2)-p2) AND p1.ProducerID < p2.ProducerID
ORDER BY al.Title;
GO

-- ============================================================
-- РАЗДЕЛ 6: SHORTEST_PATH
-- ============================================================

-- SHORTEST_PATH 1: Цепочки владения лейблами (шаблон "+")
SELECT
    src.LabelName                                           AS НачальныйЛейбл,
    LAST_VALUE(through.LabelName)
        WITHIN GROUP (GRAPH PATH)                           AS КонечныйЛейбл,
    COUNT(ow.AcquisitionYear)
        WITHIN GROUP (GRAPH PATH)                           AS ГлубинаЦепочки,
    STRING_AGG(through.LabelName, N' -> ')
        WITHIN GROUP (GRAPH PATH)                           AS ПутьЧерезЛейблы,
    STRING_AGG(CAST(ow.StakePct AS NVARCHAR(10)), N'% -> ')
        WITHIN GROUP (GRAPH PATH)                           AS ДолиВладения
FROM
    Labels              AS src,
    OwnsRights FOR PATH AS ow,
    Labels     FOR PATH AS through
WHERE
    MATCH(SHORTEST_PATH(src(-(ow)->through)+))
    AND src.LabelName = N'Universal Music Group'
ORDER BY ГлубинаЦепочки;
GO

-- SHORTEST_PATH 2: Продюсер -> Артист через 1-3 шага (шаблон {1,3})
SELECT
    src.FullName                                            AS НачальныйПродюсер,
    LAST_VALUE(through.StageName)
        WITHIN GROUP (GRAPH PATH)                           AS КонечныйАртист,
    COUNT(c.SinceYear)
        WITHIN GROUP (GRAPH PATH)                           AS ДлинаПути,
    STRING_AGG(through.StageName, N' -> ')
        WITHIN GROUP (GRAPH PATH)                           AS ПромежуточныеАртисты,
    STRING_AGG(CAST(c.SinceYear AS NVARCHAR(6)), N' -> ')
        WITHIN GROUP (GRAPH PATH)                           AS ГодыСотрудничества
FROM
    Producers            AS src,
    Collaborates FOR PATH AS c,
    Artists      FOR PATH AS through
WHERE
    MATCH(SHORTEST_PATH(src(-(c)->through){1,3}))
    AND src.FullName = N'Dr. Dre'
ORDER BY ДлинаПути;
GO

-- ============================================================
-- Данные для Power BI — Force-Directed Graph
-- ============================================================
SELECT a.StageName AS Source, l.LabelName AS Target,
       sw.RoyaltyPct AS Weight, N'SignedWith' AS EdgeType
FROM Artists AS a, SignedWith AS sw, Labels AS l
WHERE MATCH(a-(sw)->l)
UNION ALL
SELECT p.FullName AS Source, a.StageName AS Target,
       CAST(c.ProjectCount AS FLOAT) AS Weight, N'Collaborates' AS EdgeType
FROM Producers AS p, Collaborates AS c, Artists AS a
WHERE MATCH(p-(c)->a)
UNION ALL
SELECT a.StageName AS Source, al.Title AS Target,
       al.SalesM AS Weight, N'Released' AS EdgeType
FROM Artists AS a, Released AS r, Albums AS al
WHERE MATCH(a-(r)->al)
UNION ALL
SELECT l1.LabelName AS Source, l2.LabelName AS Target,
       l1.Revenue_M / 100.0 AS Weight, N'OwnsRights' AS EdgeType
FROM Labels AS l1, OwnsRights AS o, Labels AS l2
WHERE MATCH(l1-(o)->l2);
GO