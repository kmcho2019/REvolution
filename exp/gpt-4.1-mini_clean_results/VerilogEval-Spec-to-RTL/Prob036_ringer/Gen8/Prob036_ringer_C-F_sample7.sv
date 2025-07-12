module TopModule (
    input  wire ring,
    input  wire vibrate_mode,
    output wire ringer,
    output wire motor
);

// Intermediate enable signal indicating ringing is active
wire ring_enable = ring;

// Outputs are mutually exclusive, controlled by vibrate_mode
assign ringer = ring_enable & (~vibrate_mode);
assign motor  = ring_enable & vibrate_mode;

endmodule