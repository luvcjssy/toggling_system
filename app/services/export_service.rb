class ExportService
  def initialize(workbook, user, class_ids = nil, school_ids = nil)
    @workbook = workbook
    @user = user
    @class_ids = class_ids
    @school_ids = school_ids
  end

  def tracking
    if @user.teacher?
      export_for_teacher
    elsif @user.school_owner?
      export_for_school_owner
    elsif @user.hq_owner?
      export_for_hq_owner
    end

    @workbook
  end

  def export_for_teacher
    trackings = Tracking.joins(:school_class)
                  .where(school_classes: {teacher_id: @user.id})
                  .select('trackings.id, trackings.child_name, trackings.time_check_in, trackings.time_check_out, school_classes.name AS class_name')
                  .order(time_check_in: :desc)

    worksheet = @workbook.add_worksheet("Example Report")

    date_format = @workbook.number_format("[$-409]m/d/yy h:mm AM/PM;@")
    worksheet.set_column(2, 3, 20, date_format)

    worksheet.append_row(['S/N', 'Child Name', 'Check In', 'Check Out', 'Class Name', 'Teacher Name'])

    trackings.each_with_index do |tracking, index|
      worksheet.append_row([index, tracking.child_name, tracking.time_check_in, tracking.time_check_out, tracking.class_name, @user.name])
    end
  end

  def export_for_school_owner
    sql = "SELECT trackings.id, trackings.child_name, trackings.time_check_in, trackings.time_check_out, school_classes.name AS class_name, users.name AS teacher_name
           FROM trackings INNER JOIN school_classes ON trackings.school_class_id = school_classes.id
            INNER JOIN schools ON schools.id = school_classes.school_id
            INNER JOIN users ON users.id = school_classes.teacher_id
           WHERE schools.owner_id = #{@user.id}
              AND (schools.payment_type = #{School.payment_types[:paid]} #{@class_ids.present? ? "OR school_classes.id IN (#{@class_ids})" : nil})
           ORDER BY trackings.time_check_in DESC"

    trackings = Tracking.find_by_sql(sql)

    trackings.group_by(&:class_name).each do |key, value|
      worksheet = @workbook.add_worksheet(key)

      date_format = @workbook.number_format("[$-409]m/d/yy h:mm AM/PM;@")
      worksheet.set_column(2, 3, 20, date_format)

      worksheet.append_row(['S/N', 'Child Name', 'Check In', 'Check Out', 'Class Name', 'Teacher Name'])

      value.each_with_index do |tracking, index|
        worksheet.append_row([index + 1, tracking.child_name, tracking.time_check_in, tracking.time_check_out, tracking.class_name, tracking.teacher_name])
      end
    end
  end

  def export_for_hq_owner
    free_school_query = if @school_ids.present?
                          "UNION ALL
                            SELECT schools.id, schools.name
                            FROM schools
                            WHERE id in (#{@school_ids})"
                        end
    sql = "WITH RECURSIVE cte_schools AS (
                  SELECT id, name
                  FROM schools
                  WHERE owner_id = #{@user.id} AND payment_type = #{School.payment_types[:paid]} AND parent_id is NULL
              UNION ALL
                  SELECT s.id, s.name
              FROM schools s
                  inner JOIN cte_schools ON s.parent_id = cte_schools.id
          ), cte_schools_2 AS (
            SELECT * FROM cte_schools #{free_school_query}
          )

          SELECT trackings.id, trackings.child_name, trackings.time_check_in, trackings.time_check_out, school_classes.name AS class_name, users.name AS teacher_name, cte_schools_2.name AS school_name
          FROM trackings INNER JOIN school_classes on trackings.school_class_id = school_classes.id
            INNER JOIN users ON users.id = school_classes.teacher_id
            INNER JOIN schools ON schools.id = school_classes.school_id
            INNER JOIN cte_schools_2 ON cte_schools_2.id = school_classes.school_id
          ORDER BY trackings.time_check_in DESC"

    trackings = Tracking.find_by_sql(sql)

    trackings.group_by(&:school_name).each do |key, value|
      worksheet = @workbook.add_worksheet(key)

      date_format = @workbook.number_format("[$-409]m/d/yy h:mm AM/PM;@")
      worksheet.set_column(2, 3, 20, date_format)

      worksheet.append_row(['S/N', 'Child Name', 'Check In', 'Check Out', 'Class Name', 'Teacher Name'])

      value.each_with_index do |tracking, index|
        worksheet.append_row([index + 1, tracking.child_name, tracking.time_check_in, tracking.time_check_out, tracking.class_name, tracking.teacher_name])
      end
    end
  end
end
