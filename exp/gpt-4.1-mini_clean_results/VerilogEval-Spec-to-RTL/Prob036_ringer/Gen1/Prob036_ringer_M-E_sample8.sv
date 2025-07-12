module TopModule(
    input ring,
    input vibrate_mode,
    output ringer,
    output motor
);

wire [1:0] out_vec;

assign out_vec = ring ? (vibrate_mode ? 2'b10 : 2'b01) : 2'b00;
// out_vec[1] => motor
// out_vec[0] => ringer

assign motor = out_vec[1];
assign ringer = out_vec[0];

endmodule