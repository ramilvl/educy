/*
  Warnings:

  - A unique constraint covering the columns `[resetToken]` on the table `users` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `updatedAt` to the `files` table without a default value. This is not possible if the table is not empty.

*/
-- CreateEnum
CREATE TYPE "educy"."FileStatus" AS ENUM ('PENDING', 'UPLOADED', 'FAILED');

-- CreateEnum
CREATE TYPE "educy"."UserStatus" AS ENUM ('PENDING', 'ACTIVE', 'SUSPENDED', 'DELETED');

-- CreateEnum
CREATE TYPE "educy"."UserReportStatus" AS ENUM ('PENDING', 'REVIEWED', 'DISMISSED', 'ACTIONED');

-- AlterTable
ALTER TABLE "educy"."assignments" ADD COLUMN     "isArchived" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP;

-- AlterTable
ALTER TABLE "educy"."enrollments" ADD COLUMN     "enrolledById" TEXT;

-- AlterTable
ALTER TABLE "educy"."files" ADD COLUMN     "status" "educy"."FileStatus" NOT NULL DEFAULT 'PENDING',
ADD COLUMN     "updatedAt" TIMESTAMP(3) NOT NULL;

-- AlterTable
ALTER TABLE "educy"."lessons" ADD COLUMN     "isArchived" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP;

-- AlterTable
ALTER TABLE "educy"."submissions" ADD COLUMN     "isLate" BOOLEAN NOT NULL DEFAULT false;

-- AlterTable
ALTER TABLE "educy"."users" ADD COLUMN     "expertise" TEXT[] DEFAULT ARRAY[]::TEXT[],
ADD COLUMN     "phone" TEXT,
ADD COLUMN     "resetToken" TEXT,
ADD COLUMN     "resetTokenExpiry" TIMESTAMP(3),
ADD COLUMN     "status" "educy"."UserStatus" NOT NULL DEFAULT 'ACTIVE',
ADD COLUMN     "surname" TEXT,
ADD COLUMN     "welcomeEmailSent" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "welcomeEmailSentAt" TIMESTAMP(3),
ALTER COLUMN "hashedPassword" DROP NOT NULL;

-- CreateTable
CREATE TABLE "educy"."announcements" (
    "id" TEXT NOT NULL,
    "sectionId" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "content" TEXT NOT NULL,
    "authorId" TEXT NOT NULL,
    "isArchived" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "announcements_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "educy"."certificates" (
    "id" TEXT NOT NULL,
    "certificateNumber" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "sectionId" TEXT NOT NULL,
    "enrollmentId" TEXT NOT NULL,
    "completionDate" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "issuedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "issuedById" TEXT,

    CONSTRAINT "certificates_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "educy"."tab_switches" (
    "id" TEXT NOT NULL,
    "assignmentId" TEXT NOT NULL,
    "studentId" TEXT NOT NULL,
    "submissionId" TEXT,
    "timestamp" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "eventType" TEXT NOT NULL,

    CONSTRAINT "tab_switches_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "educy"."exams" (
    "id" TEXT NOT NULL,
    "sectionId" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "description" TEXT,
    "durationMinutes" INTEGER NOT NULL,
    "startTime" TIMESTAMP(3) NOT NULL,
    "endTime" TIMESTAMP(3) NOT NULL,
    "isGroupExam" BOOLEAN NOT NULL DEFAULT false,
    "createdById" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "exams_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "educy"."exam_questions" (
    "id" TEXT NOT NULL,
    "examId" TEXT NOT NULL,
    "questionText" TEXT NOT NULL,
    "questionType" TEXT NOT NULL,
    "options" JSONB,
    "correctAnswer" TEXT,
    "points" DOUBLE PRECISION NOT NULL DEFAULT 1,
    "orderIndex" INTEGER NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "exam_questions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "educy"."exam_attempts" (
    "id" TEXT NOT NULL,
    "examId" TEXT NOT NULL,
    "studentId" TEXT,
    "groupId" TEXT,
    "startedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "submittedAt" TIMESTAMP(3),
    "timeRemaining" INTEGER,
    "score" DOUBLE PRECISION,
    "isCompleted" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "exam_attempts_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "educy"."exam_groups" (
    "id" TEXT NOT NULL,
    "examId" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "exam_groups_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "educy"."exam_group_members" (
    "id" TEXT NOT NULL,
    "groupId" TEXT NOT NULL,
    "studentId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "exam_group_members_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "educy"."exam_answers" (
    "id" TEXT NOT NULL,
    "attemptId" TEXT NOT NULL,
    "questionId" TEXT NOT NULL,
    "answer" TEXT,
    "isCorrect" BOOLEAN,
    "points" DOUBLE PRECISION,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "exam_answers_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "educy"."exam_individual_scores" (
    "id" TEXT NOT NULL,
    "attemptId" TEXT NOT NULL,
    "studentId" TEXT NOT NULL,
    "score" DOUBLE PRECISION NOT NULL,
    "feedback" TEXT,
    "gradedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "gradedById" TEXT NOT NULL,

    CONSTRAINT "exam_individual_scores_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "educy"."case_rooms" (
    "id" TEXT NOT NULL,
    "sectionId" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "description" TEXT,
    "dueDate" TIMESTAMP(3),
    "createdById" TEXT NOT NULL,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "case_rooms_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "educy"."case_posts" (
    "id" TEXT NOT NULL,
    "roomId" TEXT NOT NULL,
    "studentId" TEXT NOT NULL,
    "content" TEXT NOT NULL,
    "fileKeys" TEXT[],
    "isApproved" BOOLEAN,
    "approvedById" TEXT,
    "approvedAt" TIMESTAMP(3),
    "feedback" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "case_posts_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "educy"."payments" (
    "id" TEXT NOT NULL,
    "studentId" TEXT NOT NULL,
    "amount" DOUBLE PRECISION NOT NULL,
    "currency" TEXT NOT NULL DEFAULT 'USD',
    "paymentMonth" TIMESTAMP(3) NOT NULL,
    "status" TEXT NOT NULL,
    "statusReason" TEXT,
    "paidAt" TIMESTAMP(3),
    "paymentMethod" TEXT,
    "receiptUrl" TEXT,
    "notes" TEXT,
    "recordedById" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "payments_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "educy"."user_reports" (
    "id" TEXT NOT NULL,
    "reportedById" TEXT NOT NULL,
    "reportedUserId" TEXT NOT NULL,
    "reason" TEXT NOT NULL,
    "evidence" TEXT,
    "status" "educy"."UserReportStatus" NOT NULL DEFAULT 'PENDING',
    "reviewedById" TEXT,
    "reviewedAt" TIMESTAMP(3),
    "reviewNotes" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "user_reports_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "educy"."comment_bans" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "bannedById" TEXT NOT NULL,
    "reason" TEXT NOT NULL,
    "durationHours" INTEGER NOT NULL,
    "expiresAt" TIMESTAMP(3) NOT NULL,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "comment_bans_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "educy"."system_settings" (
    "id" TEXT NOT NULL,
    "platformName" TEXT NOT NULL DEFAULT 'Educy',
    "platformLogoUrl" TEXT,
    "systemEmailFrom" TEXT,
    "systemEmailName" TEXT,
    "passwordMinLength" INTEGER NOT NULL DEFAULT 8,
    "passwordRequireUpper" BOOLEAN NOT NULL DEFAULT true,
    "passwordRequireLower" BOOLEAN NOT NULL DEFAULT true,
    "passwordRequireNumber" BOOLEAN NOT NULL DEFAULT true,
    "passwordRequireSpecial" BOOLEAN NOT NULL DEFAULT false,
    "maxUploadSizeMB" INTEGER NOT NULL DEFAULT 10,
    "enableCaseRooms" BOOLEAN NOT NULL DEFAULT true,
    "enableExams" BOOLEAN NOT NULL DEFAULT true,
    "enableCertificates" BOOLEAN NOT NULL DEFAULT true,
    "enablePayments" BOOLEAN NOT NULL DEFAULT true,
    "lastModifiedBy" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "system_settings_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "announcements_sectionId_idx" ON "educy"."announcements"("sectionId");

-- CreateIndex
CREATE INDEX "announcements_isArchived_idx" ON "educy"."announcements"("isArchived");

-- CreateIndex
CREATE INDEX "announcements_updatedAt_idx" ON "educy"."announcements"("updatedAt");

-- CreateIndex
CREATE UNIQUE INDEX "certificates_certificateNumber_key" ON "educy"."certificates"("certificateNumber");

-- CreateIndex
CREATE UNIQUE INDEX "certificates_enrollmentId_key" ON "educy"."certificates"("enrollmentId");

-- CreateIndex
CREATE INDEX "certificates_userId_idx" ON "educy"."certificates"("userId");

-- CreateIndex
CREATE INDEX "certificates_certificateNumber_idx" ON "educy"."certificates"("certificateNumber");

-- CreateIndex
CREATE INDEX "certificates_sectionId_idx" ON "educy"."certificates"("sectionId");

-- CreateIndex
CREATE INDEX "tab_switches_assignmentId_idx" ON "educy"."tab_switches"("assignmentId");

-- CreateIndex
CREATE INDEX "tab_switches_studentId_idx" ON "educy"."tab_switches"("studentId");

-- CreateIndex
CREATE INDEX "tab_switches_submissionId_idx" ON "educy"."tab_switches"("submissionId");

-- CreateIndex
CREATE INDEX "tab_switches_timestamp_idx" ON "educy"."tab_switches"("timestamp");

-- CreateIndex
CREATE INDEX "exams_sectionId_idx" ON "educy"."exams"("sectionId");

-- CreateIndex
CREATE INDEX "exams_startTime_idx" ON "educy"."exams"("startTime");

-- CreateIndex
CREATE INDEX "exams_endTime_idx" ON "educy"."exams"("endTime");

-- CreateIndex
CREATE INDEX "exam_questions_examId_idx" ON "educy"."exam_questions"("examId");

-- CreateIndex
CREATE INDEX "exam_attempts_examId_idx" ON "educy"."exam_attempts"("examId");

-- CreateIndex
CREATE INDEX "exam_attempts_studentId_idx" ON "educy"."exam_attempts"("studentId");

-- CreateIndex
CREATE INDEX "exam_attempts_groupId_idx" ON "educy"."exam_attempts"("groupId");

-- CreateIndex
CREATE UNIQUE INDEX "exam_attempts_examId_studentId_key" ON "educy"."exam_attempts"("examId", "studentId");

-- CreateIndex
CREATE INDEX "exam_groups_examId_idx" ON "educy"."exam_groups"("examId");

-- CreateIndex
CREATE INDEX "exam_group_members_groupId_idx" ON "educy"."exam_group_members"("groupId");

-- CreateIndex
CREATE INDEX "exam_group_members_studentId_idx" ON "educy"."exam_group_members"("studentId");

-- CreateIndex
CREATE UNIQUE INDEX "exam_group_members_groupId_studentId_key" ON "educy"."exam_group_members"("groupId", "studentId");

-- CreateIndex
CREATE INDEX "exam_answers_attemptId_idx" ON "educy"."exam_answers"("attemptId");

-- CreateIndex
CREATE INDEX "exam_answers_questionId_idx" ON "educy"."exam_answers"("questionId");

-- CreateIndex
CREATE UNIQUE INDEX "exam_answers_attemptId_questionId_key" ON "educy"."exam_answers"("attemptId", "questionId");

-- CreateIndex
CREATE INDEX "exam_individual_scores_attemptId_idx" ON "educy"."exam_individual_scores"("attemptId");

-- CreateIndex
CREATE INDEX "exam_individual_scores_studentId_idx" ON "educy"."exam_individual_scores"("studentId");

-- CreateIndex
CREATE UNIQUE INDEX "exam_individual_scores_attemptId_studentId_key" ON "educy"."exam_individual_scores"("attemptId", "studentId");

-- CreateIndex
CREATE INDEX "case_rooms_sectionId_idx" ON "educy"."case_rooms"("sectionId");

-- CreateIndex
CREATE INDEX "case_rooms_createdById_idx" ON "educy"."case_rooms"("createdById");

-- CreateIndex
CREATE INDEX "case_posts_roomId_idx" ON "educy"."case_posts"("roomId");

-- CreateIndex
CREATE INDEX "case_posts_studentId_idx" ON "educy"."case_posts"("studentId");

-- CreateIndex
CREATE INDEX "case_posts_isApproved_idx" ON "educy"."case_posts"("isApproved");

-- CreateIndex
CREATE INDEX "payments_studentId_idx" ON "educy"."payments"("studentId");

-- CreateIndex
CREATE INDEX "payments_paymentMonth_idx" ON "educy"."payments"("paymentMonth");

-- CreateIndex
CREATE INDEX "payments_status_idx" ON "educy"."payments"("status");

-- CreateIndex
CREATE INDEX "user_reports_reportedById_idx" ON "educy"."user_reports"("reportedById");

-- CreateIndex
CREATE INDEX "user_reports_reportedUserId_idx" ON "educy"."user_reports"("reportedUserId");

-- CreateIndex
CREATE INDEX "user_reports_status_idx" ON "educy"."user_reports"("status");

-- CreateIndex
CREATE INDEX "user_reports_createdAt_idx" ON "educy"."user_reports"("createdAt");

-- CreateIndex
CREATE INDEX "comment_bans_userId_idx" ON "educy"."comment_bans"("userId");

-- CreateIndex
CREATE INDEX "comment_bans_bannedById_idx" ON "educy"."comment_bans"("bannedById");

-- CreateIndex
CREATE INDEX "comment_bans_expiresAt_idx" ON "educy"."comment_bans"("expiresAt");

-- CreateIndex
CREATE INDEX "comment_bans_isActive_idx" ON "educy"."comment_bans"("isActive");

-- CreateIndex
CREATE INDEX "assignments_sectionId_idx" ON "educy"."assignments"("sectionId");

-- CreateIndex
CREATE INDEX "assignments_dueDate_idx" ON "educy"."assignments"("dueDate");

-- CreateIndex
CREATE INDEX "assignments_isArchived_idx" ON "educy"."assignments"("isArchived");

-- CreateIndex
CREATE INDEX "assignments_updatedAt_idx" ON "educy"."assignments"("updatedAt");

-- CreateIndex
CREATE INDEX "audit_logs_action_idx" ON "educy"."audit_logs"("action");

-- CreateIndex
CREATE INDEX "audit_logs_severity_idx" ON "educy"."audit_logs"("severity");

-- CreateIndex
CREATE INDEX "audit_logs_userId_idx" ON "educy"."audit_logs"("userId");

-- CreateIndex
CREATE INDEX "audit_logs_createdAt_idx" ON "educy"."audit_logs"("createdAt");

-- CreateIndex
CREATE INDEX "enrollments_status_idx" ON "educy"."enrollments"("status");

-- CreateIndex
CREATE INDEX "enrollments_sectionId_status_idx" ON "educy"."enrollments"("sectionId", "status");

-- CreateIndex
CREATE INDEX "enrollments_enrolledById_idx" ON "educy"."enrollments"("enrolledById");

-- CreateIndex
CREATE INDEX "files_ownerId_idx" ON "educy"."files"("ownerId");

-- CreateIndex
CREATE INDEX "files_status_idx" ON "educy"."files"("status");

-- CreateIndex
CREATE INDEX "lessons_isArchived_idx" ON "educy"."lessons"("isArchived");

-- CreateIndex
CREATE INDEX "lessons_updatedAt_idx" ON "educy"."lessons"("updatedAt");

-- CreateIndex
CREATE INDEX "notifications_userId_readAt_idx" ON "educy"."notifications"("userId", "readAt");

-- CreateIndex
CREATE INDEX "sections_term_idx" ON "educy"."sections"("term");

-- CreateIndex
CREATE INDEX "sections_instructorId_idx" ON "educy"."sections"("instructorId");

-- CreateIndex
CREATE INDEX "sections_courseId_term_idx" ON "educy"."sections"("courseId", "term");

-- CreateIndex
CREATE UNIQUE INDEX "users_resetToken_key" ON "educy"."users"("resetToken");

-- AddForeignKey
ALTER TABLE "educy"."enrollments" ADD CONSTRAINT "enrollments_enrolledById_fkey" FOREIGN KEY ("enrolledById") REFERENCES "educy"."users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "educy"."announcements" ADD CONSTRAINT "announcements_sectionId_fkey" FOREIGN KEY ("sectionId") REFERENCES "educy"."sections"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "educy"."announcements" ADD CONSTRAINT "announcements_authorId_fkey" FOREIGN KEY ("authorId") REFERENCES "educy"."users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "educy"."certificates" ADD CONSTRAINT "certificates_userId_fkey" FOREIGN KEY ("userId") REFERENCES "educy"."users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "educy"."certificates" ADD CONSTRAINT "certificates_sectionId_fkey" FOREIGN KEY ("sectionId") REFERENCES "educy"."sections"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "educy"."certificates" ADD CONSTRAINT "certificates_enrollmentId_fkey" FOREIGN KEY ("enrollmentId") REFERENCES "educy"."enrollments"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "educy"."certificates" ADD CONSTRAINT "certificates_issuedById_fkey" FOREIGN KEY ("issuedById") REFERENCES "educy"."users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "educy"."tab_switches" ADD CONSTRAINT "tab_switches_assignmentId_fkey" FOREIGN KEY ("assignmentId") REFERENCES "educy"."assignments"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "educy"."tab_switches" ADD CONSTRAINT "tab_switches_studentId_fkey" FOREIGN KEY ("studentId") REFERENCES "educy"."users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "educy"."tab_switches" ADD CONSTRAINT "tab_switches_submissionId_fkey" FOREIGN KEY ("submissionId") REFERENCES "educy"."submissions"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "educy"."exams" ADD CONSTRAINT "exams_sectionId_fkey" FOREIGN KEY ("sectionId") REFERENCES "educy"."sections"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "educy"."exams" ADD CONSTRAINT "exams_createdById_fkey" FOREIGN KEY ("createdById") REFERENCES "educy"."users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "educy"."exam_questions" ADD CONSTRAINT "exam_questions_examId_fkey" FOREIGN KEY ("examId") REFERENCES "educy"."exams"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "educy"."exam_attempts" ADD CONSTRAINT "exam_attempts_examId_fkey" FOREIGN KEY ("examId") REFERENCES "educy"."exams"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "educy"."exam_attempts" ADD CONSTRAINT "exam_attempts_studentId_fkey" FOREIGN KEY ("studentId") REFERENCES "educy"."users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "educy"."exam_attempts" ADD CONSTRAINT "exam_attempts_groupId_fkey" FOREIGN KEY ("groupId") REFERENCES "educy"."exam_groups"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "educy"."exam_group_members" ADD CONSTRAINT "exam_group_members_groupId_fkey" FOREIGN KEY ("groupId") REFERENCES "educy"."exam_groups"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "educy"."exam_group_members" ADD CONSTRAINT "exam_group_members_studentId_fkey" FOREIGN KEY ("studentId") REFERENCES "educy"."users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "educy"."exam_answers" ADD CONSTRAINT "exam_answers_attemptId_fkey" FOREIGN KEY ("attemptId") REFERENCES "educy"."exam_attempts"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "educy"."exam_answers" ADD CONSTRAINT "exam_answers_questionId_fkey" FOREIGN KEY ("questionId") REFERENCES "educy"."exam_questions"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "educy"."exam_individual_scores" ADD CONSTRAINT "exam_individual_scores_attemptId_fkey" FOREIGN KEY ("attemptId") REFERENCES "educy"."exam_attempts"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "educy"."exam_individual_scores" ADD CONSTRAINT "exam_individual_scores_studentId_fkey" FOREIGN KEY ("studentId") REFERENCES "educy"."users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "educy"."exam_individual_scores" ADD CONSTRAINT "exam_individual_scores_gradedById_fkey" FOREIGN KEY ("gradedById") REFERENCES "educy"."users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "educy"."case_rooms" ADD CONSTRAINT "case_rooms_sectionId_fkey" FOREIGN KEY ("sectionId") REFERENCES "educy"."sections"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "educy"."case_rooms" ADD CONSTRAINT "case_rooms_createdById_fkey" FOREIGN KEY ("createdById") REFERENCES "educy"."users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "educy"."case_posts" ADD CONSTRAINT "case_posts_roomId_fkey" FOREIGN KEY ("roomId") REFERENCES "educy"."case_rooms"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "educy"."case_posts" ADD CONSTRAINT "case_posts_studentId_fkey" FOREIGN KEY ("studentId") REFERENCES "educy"."users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "educy"."case_posts" ADD CONSTRAINT "case_posts_approvedById_fkey" FOREIGN KEY ("approvedById") REFERENCES "educy"."users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "educy"."payments" ADD CONSTRAINT "payments_studentId_fkey" FOREIGN KEY ("studentId") REFERENCES "educy"."users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "educy"."payments" ADD CONSTRAINT "payments_recordedById_fkey" FOREIGN KEY ("recordedById") REFERENCES "educy"."users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "educy"."user_reports" ADD CONSTRAINT "user_reports_reportedById_fkey" FOREIGN KEY ("reportedById") REFERENCES "educy"."users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "educy"."user_reports" ADD CONSTRAINT "user_reports_reportedUserId_fkey" FOREIGN KEY ("reportedUserId") REFERENCES "educy"."users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "educy"."comment_bans" ADD CONSTRAINT "comment_bans_userId_fkey" FOREIGN KEY ("userId") REFERENCES "educy"."users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "educy"."comment_bans" ADD CONSTRAINT "comment_bans_bannedById_fkey" FOREIGN KEY ("bannedById") REFERENCES "educy"."users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
