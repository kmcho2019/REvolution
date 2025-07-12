module TopModule (
    input  wire ring,
    input  wire vibrate_mode,
    output wire ringer,
    output wire motor
);

// Enable signal for either ringer or motor when ringing
wire ring_enable = ring;

// Outputs are mutually exclusive:
// If vibrate_mode=1, motor is enabled;
// If vibrate_mode=0, ringer is enabled.

// Implement outputs using ring_enable AND vibrate_mode or its complement
assign motor  = ring_enable & vibrate_mode;
assign ringer = ring_enable & (~vibrate_mode);

endmodule