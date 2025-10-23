module adder_bcd(
    input  [3:0] A,  // First BCD input
    input  [3:0] B,  // Second BCD input
    input        Cin,  // Carry-in input
    output [3:0] Sum,  // 4-bit output representing the sum of the two BCD inputs
    output       Cout  // Carry-out output
);

    // Perform binary addition of A, B, and Cin
    reg [4:0] binary_sum;
    assign binary_sum = A + B + Cin;

    // Check if the sum exceeds 9 and apply BCD correction if necessary
    always @(A, B, Cin) begin
        if (binary_sum > 9) begin
            // Apply BCD correction by adding 6 to the sum
            Sum = binary_sum + 6;
            // Generate a carry-out
            Cout = 1'b1;
        end else begin
            // No correction needed, just assign the sum
            Sum = binary_sum[3:0];
            // No carry-out if the sum does not exceed 9
            Cout = 1'b0;
        end
    end

endmodule