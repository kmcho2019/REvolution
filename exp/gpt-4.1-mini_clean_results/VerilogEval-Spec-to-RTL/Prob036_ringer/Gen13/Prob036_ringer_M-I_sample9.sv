module TopModule(
    input  wire ring,
    input  wire vibrate_mode,
    output wire ringer,
    output wire motor
);

// One-hot encoded output: bit0 = ringer, bit1 = motor
wire [1:0] out;

assign out = ring ? (vibrate_mode ? 2'b10 : 2'b01) : 2'b00;

assign ringer = out[0];
assign motor  = out[1];

endmodule