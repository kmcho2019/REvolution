module TopModule(
    input [1:0] A,
    input [1:0] B,
    output z
);

wire [1:0] xor_result; // To hold the XOR result of A and B
wire and_result;       // To hold the result of AND operation on xor_result

// Perform bitwise XOR operation between A and B
assign xor_result = A ^ B;

// Check if both bits of xor_result are 0 using logical AND
assign and_result = ~(xor_result[1] | xor_result[0]);

// Set z to 1 if A equals B, otherwise set z to 0
assign z = and_result;

endmodule