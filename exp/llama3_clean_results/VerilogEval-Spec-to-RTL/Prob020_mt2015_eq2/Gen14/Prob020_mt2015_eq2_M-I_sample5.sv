module TopModule(
    input [1:0] A,
    input [1:0] B,
    output z
);

// Use XOR operation to compare A and B
wire [1:0] xor_result;
assign xor_result = A ^ B;

// Use NOR gate or logical NOT with check for all zeros to generate z
assign z = ~(xor_result[0] | xor_result[1]);

endmodule