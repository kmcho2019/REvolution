module adder_bcd(
    input  [3:0] A,  // First BCD input
    input  [3:0] B,  // Second BCD input
    input        Cin,  // Carry-in input
    output [3:0] Sum,  // 4-bit output representing the BCD sum
    output       Cout   // Carry-out output
);

    // Perform binary addition of A, B, and Cin
    wire [4:0] bin_sum;
    assign bin_sum = A + B + Cin;

    // Check if the sum exceeds 9 and apply BCD correction if necessary
    assign Sum = (bin_sum > 9)? (bin_sum + 6) : bin_sum;

    // Generate Cout based on whether the sum exceeds 9
    assign Cout = (bin_sum > 9)? 1'b1 : 1'b0;

    // However, since Sum is a 4-bit output, we need to ensure it doesn't exceed 4 bits after correction
    // The correction of adding 6 is already considered in the previous step, so we just need to 
    // assign the lower 4 bits of the result to Sum
    assign Sum = (bin_sum > 9)? (bin_sum[3:0] + 6) : bin_sum[3:0];

    // But the above correction still doesn't correctly handle the Cout generation and Sum assignment
    // in all cases, especially when the sum exceeds 15. So, let's correctly implement it:
    reg [4:0] temp_sum;
    assign temp_sum = A + B + Cin;
    assign Sum = temp_sum[3:0];
    assign Cout = (temp_sum > 9)? 1'b1 : 1'b0;

    // Correct the Sum to be within BCD range (0-9) if it exceeds 9
    always @(A or B or Cin) begin
        if (temp_sum > 9) begin
            Sum <= (temp_sum + 6)[3:0]; // Apply correction and take lower 4 bits
        end else begin
            Sum <= temp_sum[3:0]; // No correction needed
        end
    end

    // Correct implementation with combinational logic only, without using always block:
    assign Sum = (bin_sum > 9)? (bin_sum + 6)[3:0] : bin_sum[3:0];
    assign Cout = (bin_sum > 9)? 1'b1 : 1'b0;

endmodule