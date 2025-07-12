module TopModule(
    input  wire ring,
    input  wire vibrate_mode,
    output wire ringer,
    output wire motor
);

wire [1:0] out_vec;

// Encode outputs: bit0 = ringer, bit1 = motor
assign out_vec = ring ? {vibrate_mode, ~vibrate_mode} : 2'b00;

assign ringer = out_vec[0];
assign motor  = out_vec[1];

endmodule