module TopModule (
    input ring,
    input vibrate_mode,
    output ringer,
    output motor
);

    // When ringing, select between ringer and motor based on vibrate_mode
    // The outputs are mutually exclusive by design
    assign ringer = ring & ~vibrate_mode;
    assign motor  = ring & vibrate_mode;

endmodule