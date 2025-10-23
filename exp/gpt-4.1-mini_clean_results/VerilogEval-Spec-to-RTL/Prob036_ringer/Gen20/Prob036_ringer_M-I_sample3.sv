module TopModule (
    input  wire ring,
    input  wire vibrate_mode,
    output wire ringer,
    output wire motor
);

wire enable = ring;

assign ringer = enable & ~vibrate_mode;
assign motor  = enable &  vibrate_mode;

endmodule