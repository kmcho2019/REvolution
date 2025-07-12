module TopModule(
    input [1:0] A,
    input [1:0] B,
    output reg z
);
always @(*) begin
    reg [1:0] xor_result;
    // Perform XOR operation between A and B
    xor_result = A ^ B;
    // Perform reduction OR on the XOR result
    reg or_result;
    or_result = |xor_result;
    // Invert the result of the reduction OR to get the final output
    z = ~or_result;
end
endmodule