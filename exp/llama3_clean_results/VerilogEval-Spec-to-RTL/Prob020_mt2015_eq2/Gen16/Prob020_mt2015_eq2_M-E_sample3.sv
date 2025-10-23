module TopModule(
    input [1:0] A,
    input [1:0] B,
    output reg z
);

reg [1:0] xor_result;

always @(*) begin
    xor_result = A ^ B; // Perform XOR on A and B
    z = ~(xor_result[1] | xor_result[0]); // Check if XOR result is all zeros
end

endmodule