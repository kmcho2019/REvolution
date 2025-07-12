module TopModule (
    input  wire ring,
    input  wire vibrate_mode,
    output wire ringer,
    output wire motor
);

// Synthesis directive to preserve signal and reduce glitching
// The outputs are mutually exclusive, so a 2-to-1 mux implementation is optimal.
assign ringer = ring & ~vibrate_mode; /* synthesis preserve */
assign motor  = ring & vibrate_mode;  /* synthesis preserve */

endmodule