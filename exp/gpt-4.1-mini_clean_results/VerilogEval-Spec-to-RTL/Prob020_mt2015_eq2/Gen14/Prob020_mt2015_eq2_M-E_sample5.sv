module TopModule (
    input  [1:0] A,
    input  [1:0] B,
    output       z
);

wire [1:0] xor_res;
wire       or_res;

assign xor_res = A ^ B;
assign or_res  = xor_res[0] | xor_res[1];
assign z       = ~or_res;

endmodule