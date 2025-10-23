module TopModule (
    input ring,
    input vibrate_mode,
    output ringer,
    output motor
);

    assign ringer = ring & ~vibrate_mode;  // Ring when not in vibrate mode
    assign motor  = ring & vibrate_mode;   // Vibrate when in vibrate mode

endmodule