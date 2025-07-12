module TopModule(
    input  wire ring,
    input  wire vibrate_mode,
    output wire ringer,
    output wire motor
);

wire sel = vibrate_mode & ring;
assign ringer = ring & ~vibrate_mode;
assign motor  = sel;

endmodule