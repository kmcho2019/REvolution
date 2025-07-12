module TopModule (
    input  wire ring,
    input  wire vibrate_mode,
    output wire ringer,
    output wire motor
);

    // When ring is active and vibrate_mode is low, ringer is on
    assign ringer = ring & ~vibrate_mode;

    // When ring is active and vibrate_mode is high, motor is on
    assign motor  = ring & vibrate_mode;

endmodule