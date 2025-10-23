module adder_bcd(
    input [3:0] A,  // First BCD input
    input [3:0] B,  // Second BCD input
    input Cin,     // Carry-in input
    output [3:0] Sum,  // 4-bit output representing the BCD sum
    output Cout     // Carry-out output
);

    // Internal wire to hold the binary sum of A, B, and Cin
    wire [4:0] binary_sum;

    // Perform binary addition
    assign binary_sum = {1'b0, A} + {1'b0, B} + {4'b0000, Cin};

    // If the binary sum exceeds 9 (1001), add 6 (0110) for BCD correction
    // and generate a carry-out
    assign Sum = (binary_sum > 4'd9) ? (binary_sum + 4'd6)[3:0] : binary_sum[3:0];
    assign Cout = (binary_sum > 4'd9) ? 1'b1 : binary_sum[4];

endmodule