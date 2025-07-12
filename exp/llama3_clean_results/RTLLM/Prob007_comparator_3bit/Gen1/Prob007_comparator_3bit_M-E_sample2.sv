module comparator_3bit(
    input [2:0] A,
    input [2:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

wire [2:0] xor_result;
wire [2:0] and_result;

assign xor_result = A ^ B;
assign and_result = A & ~B;

assign A_greater = (|and_result) && !(A[2] ^ B[2]);
assign A_equal = !(|xor_result);
assign A_less = (| (A ^ B)) && !(|and_result) && (A[2] == 0 && B[2] == 1);

endmodule