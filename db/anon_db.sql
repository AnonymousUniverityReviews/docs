CREATE TABLE "universities" (
  "id" SERIAL PRIMARY KEY,
  "name" nvarchar NOT NULL,
  "city" nvarchar,
  "website" nvarchar,
  "created_at" datetime
);

CREATE TABLE "allowed_email_domains" (
  "id" SERIAL PRIMARY KEY,
  "university_id" uuid NOT NULL,
  "domain" nvarchar NOT NULL
);

CREATE TABLE "faculties" (
  "id" SERIAL PRIMARY KEY,
  "university_id" uuid NOT NULL,
  "name" nvarchar NOT NULL,
  "created_at" datetime
);

CREATE TABLE "teachers" (
  "id" SERIAL PRIMARY KEY,
  "full_name" nvarchar NOT NULL,
  "created_at" datetime
);

CREATE TABLE "courses" (
  "id" SERIAL PRIMARY KEY,
  "title" nvarchar NOT NULL,
  "code" nvarchar,
  "created_at" datetime
);

CREATE TABLE "course_offerings" (
  "id" SERIAL PRIMARY KEY,
  "course_id" uuid NOT NULL,
  "faculty_id" uuid,
  "created_at" datetime
);

CREATE TABLE "course_offering_teachers" (
  "course_offering_id" uuid NOT NULL,
  "teacher_id" uuid NOT NULL
);

CREATE TABLE "users" (
  "id" SERIAL PRIMARY KEY,
  "university_id" uuid NOT NULL,
  "email_hash" nvarchar UNIQUE NOT NULL,
  "email_confirmed" bool,
  "created_at" datetime
);

CREATE TABLE "abuse_report_codes" (
  "code" nvarchar PRIMARY KEY,
  "description" text
);

CREATE TABLE "reviews" (
  "id" SERIAL PRIMARY KEY,
  "rating_overall" smallint,
  "body" text,
  "created_at" datetime
);

CREATE TABLE "university_reviews" (
  "review_id" uuid PRIMARY KEY,
  "university_id" uuid NOT NULL
);

CREATE TABLE "faculty_reviews" (
  "review_id" uuid PRIMARY KEY,
  "faculty_id" uuid NOT NULL
);

CREATE TABLE "teacher_reviews" (
  "review_id" uuid PRIMARY KEY,
  "teacher_id" uuid NOT NULL
);

CREATE TABLE "course_reviews" (
  "review_id" uuid PRIMARY KEY,
  "course_id" uuid NOT NULL
);

CREATE TABLE "course_offering_reviews" (
  "review_id" uuid PRIMARY KEY,
  "course_offering_id" uuid NOT NULL
);

CREATE TABLE "review_criteria" (
  "code" nvarchar PRIMARY KEY,
  "name" nvarchar NOT NULL,
  "description" nvarchar
);

CREATE TABLE "review_ratings" (
  "id" SERIAL PRIMARY KEY,
  "review_id" uuid NOT NULL,
  "criterion_code" nvarchar NOT NULL,
  "value" smallint NOT NULL
);

CREATE TABLE "abuse_reports" (
  "id" SERIAL PRIMARY KEY,
  "review_id" uuid NOT NULL,
  "reporter_user_id" uuid NOT NULL,
  "reason_code" nvarchar NOT NULL,
  "details" text,
  "status" nvarchar NOT NULL,
  "created_at" datetime NOT NULL
);

CREATE TABLE "abuse_report_statuses" (
  "name" nvarchar PRIMARY KEY,
  "description" nvarchar
);

CREATE UNIQUE INDEX "uq_uni_domain" ON "allowed_email_domains" ("university_id", "domain");

CREATE UNIQUE INDEX "PK" ON "course_offering_teachers" ("course_offering_id", "teacher_id");

CREATE INDEX "idx_cot_teacher" ON "course_offering_teachers" ("teacher_id");

CREATE INDEX "idx_reviews_created_at" ON "reviews" ("created_at");

CREATE INDEX "idx_university_reviews_university" ON "university_reviews" ("university_id");

CREATE INDEX "idx_faculty_reviews_faculty" ON "faculty_reviews" ("faculty_id");

CREATE INDEX "idx_teacher_reviews_teacher" ON "teacher_reviews" ("teacher_id");

CREATE INDEX "idx_course_reviews_course" ON "course_reviews" ("course_id");

CREATE INDEX "idx_co_reviews_course_offering" ON "course_offering_reviews" ("course_offering_id");

CREATE INDEX "idx_review_ratings_review" ON "review_ratings" ("review_id");

CREATE INDEX "idx_review_ratings_criterion" ON "review_ratings" ("criterion_code");

COMMENT ON COLUMN "users"."email_hash" IS 'pseudonymous key (salted hash of email)';

COMMENT ON COLUMN "reviews"."body" IS 'review text';

COMMENT ON COLUMN "review_ratings"."criterion_code" IS 'e.g. TEACHING_QUALITY, WORKLOAD';

ALTER TABLE "allowed_email_domains" ADD FOREIGN KEY ("university_id") REFERENCES "universities" ("id");

ALTER TABLE "faculties" ADD FOREIGN KEY ("university_id") REFERENCES "universities" ("id");

ALTER TABLE "course_offerings" ADD FOREIGN KEY ("course_id") REFERENCES "courses" ("id");

ALTER TABLE "course_offerings" ADD FOREIGN KEY ("faculty_id") REFERENCES "faculties" ("id");

ALTER TABLE "course_offering_teachers" ADD FOREIGN KEY ("course_offering_id") REFERENCES "course_offerings" ("id");

ALTER TABLE "course_offering_teachers" ADD FOREIGN KEY ("teacher_id") REFERENCES "teachers" ("id");

ALTER TABLE "users" ADD FOREIGN KEY ("university_id") REFERENCES "universities" ("id");

ALTER TABLE "university_reviews" ADD FOREIGN KEY ("review_id") REFERENCES "reviews" ("id");

ALTER TABLE "university_reviews" ADD FOREIGN KEY ("university_id") REFERENCES "universities" ("id");

ALTER TABLE "faculty_reviews" ADD FOREIGN KEY ("review_id") REFERENCES "reviews" ("id");

ALTER TABLE "faculty_reviews" ADD FOREIGN KEY ("faculty_id") REFERENCES "faculties" ("id");

ALTER TABLE "teacher_reviews" ADD FOREIGN KEY ("review_id") REFERENCES "reviews" ("id");

ALTER TABLE "teacher_reviews" ADD FOREIGN KEY ("teacher_id") REFERENCES "teachers" ("id");

ALTER TABLE "course_reviews" ADD FOREIGN KEY ("review_id") REFERENCES "reviews" ("id");

ALTER TABLE "course_reviews" ADD FOREIGN KEY ("course_id") REFERENCES "courses" ("id");

ALTER TABLE "course_offering_reviews" ADD FOREIGN KEY ("review_id") REFERENCES "reviews" ("id");

ALTER TABLE "course_offering_reviews" ADD FOREIGN KEY ("course_offering_id") REFERENCES "course_offerings" ("id");

ALTER TABLE "review_ratings" ADD FOREIGN KEY ("review_id") REFERENCES "reviews" ("id");

ALTER TABLE "review_ratings" ADD FOREIGN KEY ("criterion_code") REFERENCES "review_criteria" ("code");

ALTER TABLE "abuse_reports" ADD FOREIGN KEY ("review_id") REFERENCES "reviews" ("id");

ALTER TABLE "abuse_reports" ADD FOREIGN KEY ("reporter_user_id") REFERENCES "users" ("id");

ALTER TABLE "abuse_reports" ADD FOREIGN KEY ("reason_code") REFERENCES "abuse_report_codes" ("code");

ALTER TABLE "abuse_reports" ADD FOREIGN KEY ("status") REFERENCES "abuse_report_statuses" ("name");