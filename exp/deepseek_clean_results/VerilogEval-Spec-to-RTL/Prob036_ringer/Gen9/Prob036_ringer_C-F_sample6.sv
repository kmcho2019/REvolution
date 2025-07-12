module TopModule (
    input ring,
    input vibrate_mode,
    output ringer,
    output motor
);

    // Direct assignments showing clear mode selection
    assign ringer = ring & ~vibrate_mode;  // Normal mode
    assign motor  = ring &  vibrate_mode;  // Vibrate mode

endmodule