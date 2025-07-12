module TopModule(
    input [1:0] A,
    input [1:0] B,
    output reg z
);
always @(*) begin
    reg [1:0] xor_result;
    xor_result = A ^ B; // Perform bitwise XOR
    z = (xor_result == 2'b00)? 1'b1 : 1'b0; // Check if result is 0
end
endmodule