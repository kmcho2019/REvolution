module TopModule (
    input ring,
    input vibrate_mode,
    output ringer,
    output motor
);
    // Ringer is active when ring is high and not in vibrate mode
    assign ringer = ring & ~vibrate_mode;
    
    // Motor is active when ring is high and in vibrate mode
    assign motor = ring & vibrate_mode;
endmodule