module TopModule(
    input  wire ring,
    input  wire vibrate_mode,
    output wire ringer,
    output wire motor
);

wire [1:0] out = ring ? 2'b01 << vibrate_mode : 2'b00;
assign ringer = out[0];
assign motor  = out[1];

endmodule