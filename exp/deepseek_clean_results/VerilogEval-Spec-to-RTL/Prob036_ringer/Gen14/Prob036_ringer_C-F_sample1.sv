module TopModule (
    input ring,
    input vibrate_mode,
    output ringer,
    output motor
);

    // Ringing in normal mode (vibrate off)
    assign ringer = ring & ~vibrate_mode;
    
    // Ringing in vibrate mode
    assign motor = ring & vibrate_mode;

endmodule