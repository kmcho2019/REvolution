module TopModule (
    input  wire ring,
    input  wire vibrate_mode,
    output wire ringer,
    output wire motor
);

    // ringer is active only if ring is asserted and vibrate_mode is off
    assign ringer = ring & ~vibrate_mode;

    // motor is active only if ring is asserted and vibrate_mode is on
    assign motor = ring & vibrate_mode;

endmodule