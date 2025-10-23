module TopModule (
    input  wire ring,
    input  wire vibrate_mode,
    output wire ringer,
    output wire motor
);

wire active = ring;

assign ringer = active & ~vibrate_mode;
assign motor  = active & vibrate_mode;

endmodule