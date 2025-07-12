module TopModule(
    input [1:0] A,
    input [1:0] B,
    output reg z
);

always @(*) begin
    // Calculate the bitwise XOR of A and B
    reg [1:0] xor_result;
    xor_result = A ^ B;
    
    // Check if the XOR result is 0, indicating A equals B
    if (xor_result == 2'b00) begin
        z = 1'b1;
    end else begin
        z = 1'b0;
    end
end

endmodule