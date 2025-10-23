module TopModule(
    input  wire ring,
    input  wire vibrate_mode,
    output wire ringer,
    output wire motor
);

// When ring is asserted, select motor if vibrate_mode is set; otherwise, select ringer.
// This implements a 2-to-1 mux controlled by vibrate_mode.
// Only one output is asserted at a time, and only if ring=1.

assign motor  = ring & vibrate_mode;
assign ringer = ring & (~vibrate_mode);

endmodule