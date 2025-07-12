module adder_bcd (
    input   [3:0] A,  // First BCD input
    input   [3:0] B,  // Second BCD input
    input         Cin,  // Carry-in input
    output  [3:0] Sum,  // 4-bit output representing the sum
    output        Cout  // Carry-out output
);

// Temporary variables to hold the sum and carry
reg [4:0] temp_sum;
reg [4:0] corrected_sum;

// Perform binary addition of A, B, and Cin
always @(*) begin
    temp_sum = A + B + Cin;
    
    // Check if the sum exceeds 9 and apply BCD correction if necessary
    if (temp_sum > 9) begin
        corrected_sum = temp_sum + 6;
        Cout = 1'b1;  // Generate carry-out
    end else begin
        corrected_sum = temp_sum;
        Cout = 1'b0;  // No carry-out
    end
    
    // Assign the corrected sum to the output
    Sum = corrected_sum[3:0];
end

endmodule