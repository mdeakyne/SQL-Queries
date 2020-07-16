select
    year(lt.start_date) as term_year,
    ifnull(lt.name, 'Unknown Term') as term,
    replace(ifnull(h2.name, 'No Parent'),'NoName', 'Institution') as hierarchy_parent_node,
    ifnull(h1.name, 'No Node') as hierarchy_node,
    count(distinct lc.id) as course_count,
    count(distinct lp.id) as student_count,
    student_count/course_count as students_per_course,
    avg(avg_grade) avg_grade --averaging the average? Does this make sense here?
from cdm_lms.course lc

--
inner join cdm_lms.gradebook as lgb
    on lgb.course_id = lc.id
left join cdm_lms.grade as lg
    on lg.gradebook_id = lgb.id
left join (
   select
    gradebook_id,
    count(distinct person_course_id) as enrollment_count,
    sum(
     case when normalized_score between 0 and 0.5 then 1 else 0 end
    ) as fail_count,
    fail_count / enrollment_count as fail_percent,
    avg(normalized_score) as avg_grade
   from cdm_lms.grade
   where graded_cnt > 0
   group by gradebook_id
) lg_all
    on lg_all.gradebook_id = lgb.id
--

inner join cdm_lms.institution_hierarchy_course ihc
    on lc.id = ihc.course_id
    and ihc.primary_ind = 1
    and ihc.row_deleted_time is null
left join cdm_lms.institution_hierarchy h1
    on ihc.institution_hierarchy_id = h1.id
left join cdm_lms.institution_hierarchy h2
    on h1.institution_hierarchy_parent_id = h2.id 
left join cdm_lms.term lt
    on lt.id = lc.term_id
left join cdm_lms.person_course pc
    on lc.id = pc.course_id
left join cdm_lms.person lp
    on pc.person_id = lp.id
where pc.course_role = 'S' and
term_year is not null
group by
    year(lt.start_date),
    h1.name,
    h2.name,
    lt.name
order by
    year(lt.start_date) desc,
    students_per_course desc,
    lt.name,
    h1.name;