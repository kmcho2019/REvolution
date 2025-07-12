module adder_bcd(
    input   [3:0] A,  // First BCD input
    input   [3:0] B,  // Second BCD input
    input         Cin,  // Carry-in input
    output  [3:0] Sum,  // 4-bit output representing the sum of the two BCD inputs
    output        Cout  // Carry-out output
);

    // Perform binary addition of A, B, and Cin
    reg [4:0] binary_sum;
    always @(A or B or Cin) begin
        binary_sum = A + B + Cin;
    end

    // Check if the sum exceeds 9 and perform BCD correction if necessary
    always @(binary_sum) begin
        if (binary_sum > 9) begin
            // Add 6 to correct the sum back to the BCD range and generate a carry-out
            Sum = binary_sum + 6;
            Cout = 1'b1;
        end else begin
            // No correction needed, directly assign the sum and reset carry-out
            Sum = binary_sum[3:0];
            Cout = 1'b0;
        end
    end

endmodule