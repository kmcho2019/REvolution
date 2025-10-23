module TopModule (
    input ring,
    input vibrate_mode,
    output ringer,
    output motor
);

    // Ringer activates when ring is high and not in vibrate mode
    assign ringer = ring & ~vibrate_mode;
    
    // Motor activates when ring is high and in vibrate mode
    assign motor = ring & vibrate_mode;

endmodule