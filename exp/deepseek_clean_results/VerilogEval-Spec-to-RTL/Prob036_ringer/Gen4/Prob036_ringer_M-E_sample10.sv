module TopModule (
    input ring,
    input vibrate_mode,
    output ringer,
    output motor
);

    // Motor activates when in vibrate mode and ringing
    assign motor = ring & vibrate_mode;
    
    // Ringer activates when ringing but not in vibrate mode
    assign ringer = ring & ~vibrate_mode;

endmodule