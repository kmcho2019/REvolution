module TopModule(
    input  wire ring,
    input  wire vibrate_mode,
    output wire ringer,
    output wire motor
);

// mux selects which output to enable based on vibrate_mode
assign ringer = ring & (~vibrate_mode);
assign motor  = ring & vibrate_mode;

endmodule