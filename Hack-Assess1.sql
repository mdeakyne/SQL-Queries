select
    year(lt.start_date) as term_year,
    ifnull(lt.name, 'Unknown Term') as term,
    replace(ifnull(h2.name, 'No Parent'),'NoName', 'Institution') as hierarchy_parent_node,
    ifnull(h1.name, 'No Node') as hierarchy_node,
    count(distinct lc.id) as course_count,
    count(distinct lp.id) as student_count,
    student_count/course_count as students_per_course
from cdm_lms.course lc
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
where pc.course_role = 'S'
group by
    year(lt.start_date),
    h1.name,
    h2.name,
    lt.name
order by
    year(lt.start_date),
    lt.name,
    h1.name