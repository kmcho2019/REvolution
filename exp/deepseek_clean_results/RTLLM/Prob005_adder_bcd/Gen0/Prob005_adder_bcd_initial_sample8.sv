module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output reg [3:0] Sum,
    output reg Cout
);

reg [4:0] temp_sum;  // 5-bit to hold carry from addition

always @(*) begin
    // Perform binary addition
    temp_sum = A + B + Cin;
    
    // Check if sum exceeds 9 or generated carry
    if (temp_sum > 9 || temp_sum[4] == 1'b1) begin
        Sum = temp_sum[3:0] + 6;  // Add correction factor
        Cout = 1'b1;              // Set carry out
    end
    else begin
        Sum = temp_sum[3:0];      // No correction needed
        Cout = 1'b0;              // No carry out
    end
end

endmodule