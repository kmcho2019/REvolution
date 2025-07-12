module TopModule(
    input [1:0] A,
    input [1:0] B,
    output logic z
);

// Use XOR operation to compare A and B
wire [1:0] xor_result;
assign xor_result = A ^ B;

// Use logical NOT operation with check for all zeros to generate z
assign z = ~(xor_result[0] | xor_result[1]);

endmodule