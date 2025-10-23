module TopModule(
    input  wire ring,
    input  wire vibrate_mode,
    output wire ringer,
    output wire motor
);

// If ring is asserted:
// - motor is ON when vibrate_mode=1
// - ringer is ON when vibrate_mode=0
// Otherwise, both outputs are OFF.
// This ensures mutual exclusion and minimal logic.
assign {ringer, motor} = ring ? (vibrate_mode ? 2'b01 : 2'b10) : 2'b00;

endmodule