module TopModule(
    input  wire ring,
    input  wire vibrate_mode,
    output wire ringer,
    output wire motor
);

wire vibrate_mode_n = ~vibrate_mode;

// Use ring as enable; vibrate_mode selects motor or ringer
assign motor  = ring & vibrate_mode;
assign ringer = ring & vibrate_mode_n;

endmodule