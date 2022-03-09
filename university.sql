-- 1. Selezionare tutti gli studenti nati nel 1990
SELECT `date_of_birth`
FROM `students`
WHERE YEAR(`date_of_birth`) = '1990';

-- 2. Selezionare tutti i corsi che valgono più di 10 crediti
SELECT `cfu`
FROM `courses`
WHERE `cfu` >= 10

-- 3. Selezionare tutti gli studenti che hanno più di 30 anni

-- 4. Selezionare tutti i corsi del primo semestre del primo anno di un qualsiasi corso di laurea
SELECT *, `period`, `year`
FROM `courses`
WHERE `period` = 'I semestre'
AND `year` = 1

-- 5. Selezionare tutti gli appelli d'esame che avvengono nel pomeriggio (dopo le 14) del 20/06/2020
SELECT *, `hour`, `date`
FROM `exams`
WHERE `hour` LIKE '16%'
AND `date` = '2020-06-20'

-- 6. Selezionare tutti i corsi di laurea magistrale
SELECT *, `level`
FROM `degrees`
WHERE `level` = 'magistrale'