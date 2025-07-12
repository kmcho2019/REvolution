module TopModule(
    input  wire ring,
    input  wire vibrate_mode,
    output wire ringer,
    output wire motor
);

// ringer is enabled only when ring is high and vibrate_mode is low
assign ringer = ring & ~vibrate_mode;

// motor is enabled only when ring is high and vibrate_mode is high
assign motor  = ring & vibrate_mode;

endmodule