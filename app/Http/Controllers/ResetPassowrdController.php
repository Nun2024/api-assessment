<?php

namespace App\Http\Controllers;

use App\Models\User;
use Carbon\Carbon;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;

class ResetPassowrdController extends Controller
{
    public function reset(Request $request)
    {
        $request->validate([
            'email' => 'required|email',
            'password' => 'required|string|min:8|confirmed'
        ]);

        $user = User::where('email',$request->email)->first();
        if (!$user){
            return response()->json(['message' => 'email not found'],404);
        }

        if ($user->last_password_reset_at && Carbon::parse($user->last_password_reset_at)->isToday()) {
            return response()->json(['message' => 'You can only reset your password once per day.'], 429);
        }

        $user->password = Hash::make($request->password);
        $user->last_password_reset_at = Carbon::now();
        $user->save();

        return response()->json(['message' => 'password reset successfully']);

    }
}
