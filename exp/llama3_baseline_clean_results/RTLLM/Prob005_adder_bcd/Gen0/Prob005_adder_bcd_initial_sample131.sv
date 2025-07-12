module adder_bcd(
    input  [3:0] A,  // First BCD input
    input  [3:0] B,  // Second BCD input
    input        Cin,  // Carry-in input
    output [3:0] Sum,  // 4-bit output representing the sum
    output       Cout   // Carry-out output
);

    // Perform binary addition of A, B, and Cin
    reg [4:0] binary_sum;
    assign binary_sum = A + B + Cin;

    // Check if the sum exceeds 9 and apply BCD correction if necessary
    always @(A, B, Cin) begin
        if (binary_sum > 9) begin
            // Apply correction and generate carry-out
            Sum = (binary_sum + 6) % 10;
            Cout = 1'b1;
        end else begin
            // No correction needed, assign binary sum to output
            Sum = binary_sum[3:0];
            Cout = 1'b0;
        end
    end

endmodule