module adder_bcd(
    input [3:0] A,  // First BCD input
    input [3:0] B,  // Second BCD input
    input Cin,      // Carry-in input
    output [3:0] Sum,  // 4-bit output representing the sum
    output Cout      // Carry-out output
);

    wire [4:0] binary_sum;  // Temporary variable to hold binary sum

    // Perform binary addition of A, B, and Cin
    assign binary_sum = {1'b0, A} + {1'b0, B} + {4'b0000, Cin};

    // Check if the sum exceeds 9 (binary 1001)
    assign Cout = (binary_sum > 4'd9) ? 1'b1 : 1'b0;

    // If sum exceeds 9, add 6 for BCD correction
    assign Sum = (binary_sum > 4'd9) ? binary_sum[3:0] + 4'd6 : binary_sum[3:0];

endmodule