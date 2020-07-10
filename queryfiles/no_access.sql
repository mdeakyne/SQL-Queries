SELECT SUBSTR(REGEXP_SUBSTR(cm.COURSE_NAME, '-[A-Z&]+'),2) COURSE_UNIT,
       SUBSTR(REGEXP_SUBSTR(cm.COURSE_NAME, ' [A-Z]{3}$'),2) COURSE_TYPE,
       REPLACE(cm.COURSE_NAME,',',' ') COURSE_NAME,
       cm.COURSE_ID,
       cm.AVAILABLE_IND,
       MAX(cu.LAST_ACCESS_DATE) last_access,
       SUM(students.students)/COUNT(students.students) student_count,
       listagg(u.email, ';') WITHIN GROUP (order by u.email) emails,
       listagg(u.firstname || ' ' || u.LASTNAME, ';') WITHIN GROUP (order by u.email) names

FROM BB_BB60.USERS u inner join BB_BB60.COURSE_USERS cu on u.pk1 = cu.USERS_PK1
inner join BB_BB60.COURSE_MAIN cm on cu.CRSMAIN_PK1 = cm.pk1
left join (select crsmain_pk1, count(pk1) students
    from bb_bb60.COURSE_USERS
    where role='S'
    and row_status = 0
    group by crsmain_pk1) students on students.crsmain_pk1 = cm.pk1

WHERE cm.COURSE_NAME LIKE '2020' || :season ||'-%' AND (cu.ROLE='P' OR cu.ROLE='T') AND
      NOT EXISTS (SELECT cc.crsmain_pk1 course_id
      from bb_bb60.COURSE_COURSE cc WHERE cc.CRSMAIN_PK1 = cm.pk1)

GROUP BY cm.COURSE_NAME, cm.COURSE_ID, cm.AVAILABLE_IND
HAVING SUM(students.students)/COUNT(students.students) IS NOT NULL
ORDER BY student_count desc
