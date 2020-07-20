hq_owner = User.create email: 'hq_owner@example.com', password: '12345678', role: :hq_owner, name: Faker::Name.name
school_owner = User.create email: 'school_owner@example.com', password: '12345678', role: :school_owner, name: Faker::Name.name
teacher = User.create email: 'teacher@example.com', password: '12345678', role: :teacher, name: Faker::Name.name

5.times do
  school = School.create name: Faker::Educator.university, payment_type: [:free, :paid].sample, owner_id: hq_owner.id

  3.times do
    classroom = SchoolClass.create name: Faker::Educator.subject, year: 2020, teacher_id: teacher.id, school_id: school.id
    10.times do
      Tracking.create child_name: Faker::Name.name, school_class_id: classroom.id, time_check_in: Time.now, time_check_out: Time.now + 5.hours
    end
  end
end

hq_school_ids = School.hq.ids
5.times do
  school = School.create name: Faker::Educator.university, payment_type: [:free, :paid].sample, parent_id: hq_school_ids.sample, owner_id: school_owner.id

  3.times do
    classroom = SchoolClass.create name: Faker::Educator.subject, year: 2020, teacher_id: teacher.id, school_id: school.id
    10.times do
      Tracking.create child_name: Faker::Name.name, school_class_id: classroom.id, time_check_in: Time.now, time_check_out: Time.now + 5.hours
    end
  end
end

