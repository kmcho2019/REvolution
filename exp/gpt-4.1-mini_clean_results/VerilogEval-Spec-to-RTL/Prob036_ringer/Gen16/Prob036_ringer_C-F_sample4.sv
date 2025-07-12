module TopModule(
    input  wire ring,
    input  wire vibrate_mode,
    output wire ringer,
    output wire motor
);

// Use mux-style assignments to enable mutual exclusivity and reduce gate count.
assign ringer = ring & (~vibrate_mode);
assign motor  = ring & vibrate_mode;

endmodule