module TopModule(
    input [1:0] A,
    input [1:0] B,
    output reg z
);

wire [1:0] xor_result;
assign xor_result = A ^ B;
assign z = ~(xor_result[1] | xor_result[0]);

endmodule