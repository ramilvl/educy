-- CreateEnum
CREATE TYPE "educy"."AuditLogSeverity" AS ENUM ('INFO', 'WARNING', 'CRITICAL');

-- AlterEnum
-- This migration adds more than one value to an enum.
-- With PostgreSQL versions 11 and earlier, this is not possible
-- in a single migration. This can be worked around by creating
-- multiple migrations, each migration adding only one value to
-- the enum.


ALTER TYPE "educy"."EnrollmentStatus" ADD VALUE 'REJECTED';
ALTER TYPE "educy"."EnrollmentStatus" ADD VALUE 'WAITLISTED';

-- AlterTable
ALTER TABLE "educy"."audit_logs" ADD COLUMN     "category" TEXT,
ADD COLUMN     "severity" "educy"."AuditLogSeverity" NOT NULL DEFAULT 'INFO';
