module TopModule (
    input  [1:0] A,
    input  [1:0] B,
    output       z
);

wire [1:0] xor_result;

// XOR of inputs per bit
assign xor_result = A ^ B;

// NOR of all XOR bits: output 1 if xor_result is 0 (inputs equal)
assign z = ~(xor_result[0] | xor_result[1]);

endmodule