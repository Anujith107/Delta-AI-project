import { NextResponse } from 'next/server';
import type { NextRequest } from 'next/server';

export function middleware(request: NextRequest) {
  // In a complete implementation, this would verify the Firebase token
  // For now, we allow the request to proceed and rely on client-side protection
  return NextResponse.next();
}

export const config = {
  matcher: ['/dashboard/:path*'],
};
