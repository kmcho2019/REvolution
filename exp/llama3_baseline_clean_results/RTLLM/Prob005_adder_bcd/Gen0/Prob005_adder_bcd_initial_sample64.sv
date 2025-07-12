module adder_bcd(
    input   [3:0] A,  // First BCD input (4-bit)
    input   [3:0] B,  // Second BCD input (4-bit)
    input         Cin,  // Carry-in input (1-bit)
    output  [3:0] Sum,  // 4-bit output representing the sum of the two BCD inputs
    output        Cout  // Carry-out output (1-bit)
);

    // Perform binary addition of A, B, and Cin
    wire [4:0] binary_sum;
    assign binary_sum = {1'b0, A} + {1'b0, B} + {3'b000, Cin};

    // Apply BCD correction if the sum exceeds 9
    wire [3:0] sum_with_correction;
    assign sum_with_correction = (binary_sum[4])? (binary_sum[3:0] + 4'd6) : binary_sum[3:0];

    // Assign the final sum and carry-out
    assign Sum = sum_with_correction;
    assign Cout = binary_sum[4];

endmodule