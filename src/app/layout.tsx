import type { Metadata } from "next";

export const metadata: Metadata = {
  title: "Jetpack Joyride",
  description: "Neon Jetpack Joyride game",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en">
      <body>{children}</body>
    </html>
  );
}