module TopModule (
    input ring,
    input vibrate_mode,
    output ringer,
    output motor
);

    // Silent mode when not ringing
    wire silent_mode = ~ring;
    
    // Generate ringer signal (only when not in vibrate mode and ringing)
    assign ringer = ring & ~vibrate_mode & ~silent_mode;
    
    // Generate motor signal (only when in vibrate mode and ringing)
    assign motor = ring & vibrate_mode & ~silent_mode;

endmodule