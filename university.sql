-- 1. Selezionare tutti gli studenti nati nel 1990
SELECT *, `date_of_birth` AS 'Anno di nascita'
FROM `students`
WHERE YEAR(`date_of_birth`) = '1990';

-- 2. Selezionare tutti i corsi che valgono più di 10 crediti
SELECT *, `cfu`
FROM `courses`
WHERE `cfu` > 10

-- 3. Selezionare tutti gli studenti che hanno più di 30 anni
SELECT *
FROM `students`
WHERE `date_of_birth` <= '1992-03-10'

SELECT *
FROM `students`
WHERE TIMESTAMPDIFF(YEAR, `date_of_birth`, CURDATE()) > 30

SELECT *
FROM `students`
WHERE YEAR(CURDATE()) - YEAR(`date_of_birth`) > 30

SELECT *
FROM `students`
WHERE `date_of_birth` < DATE_SUB(CURDATE(), INTERVAL 30 YEAR)

-- 4. Selezionare tutti i corsi del primo semestre del primo anno di un qualsiasi corso di laurea
SELECT *, `period`, `year`
FROM `courses`
WHERE `period` = 'I semestre'
AND `year` = 1

-- 5. Selezionare tutti gli appelli d'esame che avvengono nel pomeriggio (dopo le 14) del 20/06/2020
SELECT *, `hour`, `date`
FROM `exams`
WHERE HOUR(`hour`) > '14'
AND `date` = '2020-06-20'

-- 6. Selezionare tutti i corsi di laurea magistrale
SELECT *, `level`
FROM `degrees`
WHERE `level` = 'magistrale'

-- 7. Da quanti dipartimenti è composta l'università?
SELECT COUNT(*)
FROM `departments`

-- 8. Quanti sono gli insegnanti che non hanno un numero di telefono?
SELECT COUNT(*)
FROM `teachers`
WHERE `phone` IS NULL




-- # GROUP BY

-- 1. Contare quanti iscritti ci sono stati ogni anno
SELECT COUNT(*) AS 'num_iscritti', YEAR(`enrolment_date`) as `year`
FROM `students`
GROUP BY `year`

-- 2. Contare gli insegnanti che hanno l'ufficio nello stesso edificio
SELECT COUNT(*) as `num_residenti`, `office_address`
FROM `teachers`
GROUP BY `office_address`
HAVING `num_residenti` > 1

-- 3. Calcolare la media dei voti di ogni appello d'esame
SELECT ROUND(AVG(`vote`), 2) AS `media_voti`, `exam_id` as `appello`
FROM `exam_student`
GROUP BY `exam_id`

-- 4. Contare quanti corsi di laurea ci sono per ogni dipartimento
SELECT COUNT(*) as `num_corsi_laurea`, `department_id`
FROM `degrees`
GROUP BY `department_id`



-- # JOIN

-- 1. Selezionare tutti gli studenti iscritti al Corso di Laurea in Economia
SELECT `students`.`name`, `students`.`surname`, `degrees`.`name`
FROM `students`
JOIN `degrees`
ON `degrees`.`id` = `students`.`degree_id`
WHERE `degrees`.`name` = 'Corso di Laurea in Economia'

-- 2. Selezionare tutti i Corsi di Laurea del Dipartimento di Neuroscienze
SELECT `degrees`.`name`, `departments`.`name`
FROM `degrees`
JOIN `departments`
ON `departments`.`id` = `degrees`.`department_id`
WHERE `departments`.`name` = 'Dipartimento di Neuroscienze'

-- 3. Selezionare tutti i corsi in cui insegna Fulvio Amato (id=44)
SELECT `courses`.`name`, `teachers`.`name`, `teachers`.`surname`, `teachers`.`id`
FROM `courses`
JOIN `course_teacher`
ON `courses`.`id` = `course_teacher`.`course_id`
JOIN `teachers`
ON `teachers`.`id` = `course_teacher`.`teacher_id`
WHERE `teachers`.`name` = 'Fulvio'
AND `teachers`.`surname` = 'Amato'

-- 4. Selezionare tutti gli studenti con i dati relativi al corso di laurea a cui sono iscritti e il relativo dipartimento, in ordine alfabetico per cognome e nome
SELECT `students`.`name`, `students`.`surname`, `degrees`.`name`, `departments`.`name`
FROM `students`
JOIN `degrees`
ON `degrees`.`id` = `students`.`degree_id`
JOIN `departments`
ON `departments`.`id` = `degrees`.`department_id`
ORDER BY `students`.`surname` ASC, `students`.`name` ASC

-- 5. Selezionare tutti i corsi di laurea con i relativi corsi e insegnanti
SELECT `degrees`.`name`, `courses`.`name`, `teachers`.`name`, `teachers`.`surname`
FROM `degrees`
JOIN `courses`
ON `degrees`.`id` = `courses`.`degree_id`
JOIN `course_teacher`
ON `courses`.`id` = `course_teacher`.`course_id`
JOIN `teachers`
ON `teachers`.`id` = `course_teacher`.`teacher_id`

-- 6. Selezionare tutti i docenti che insegnano nel Dipartimento di Matematica (54)
SELECT DISTINCT `teachers`.`name`, `teachers`.`surname`, `departments`.`name`, `teachers`.`id`
FROM `teachers`
LEFT JOIN `course_teacher`
ON `teachers`.`id` = `course_teacher`.`teacher_id`
JOIN `courses`
ON `courses`.`id` = `course_teacher`.`course_id`
JOIN `degrees`
ON `degrees`.`id` = `courses`.`degree_id`
JOIN `departments`
ON `departments`.`id` = `degrees`.`department_id`
WHERE `departments`.`name` = 'Dipartimento di Matematica'

-- 7. BONUS: Selezionare per ogni studente quanti tentativi d'esame ha sostenuto per superare ciascuno dei suoi esami
SELECT `students`.`name`, `students`.`surname`, `courses`. `name`, COUNT(`exam_student`.`vote`) AS `num_tentativi`, MAX(`exam_student`.`vote`) AS `voto_massimo`
FROM `students`
JOIN `exam_student`
ON `students`.`id` = `exam_student`.`student_id`
JOIN `exams`
ON `exams`.`id` = `exam_student`.`exam_id`
JOIN `courses`
ON `courses`.`id` = `exams`.`course_id`
GROUP BY `students`.`id`, `courses`.`id`
HAVING `voto_massimo` >= 18