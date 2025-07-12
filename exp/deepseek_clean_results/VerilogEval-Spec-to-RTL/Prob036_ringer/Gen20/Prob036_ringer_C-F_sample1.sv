module TopModule (
    input ring,
    input vibrate_mode,
    output ringer,
    output motor
);

    // Ringer activates in normal mode (vibrate_mode=0) when ring is on
    assign ringer = ring & ~vibrate_mode;
    
    // Motor activates in vibrate mode (vibrate_mode=1) when ring is on
    assign motor  = ring & vibrate_mode;

endmodule