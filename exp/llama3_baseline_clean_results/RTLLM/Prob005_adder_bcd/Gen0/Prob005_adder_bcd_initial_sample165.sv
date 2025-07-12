module adder_bcd(
    input [3:0] A,  // First BCD input
    input [3:0] B,  // Second BCD input
    input Cin,      // Carry-in input
    output [3:0] Sum,  // 4-bit output representing the BCD sum
    output Cout      // Carry-out output
);

    // Perform binary addition of A, B, and Cin
    wire [4:0] sum_temp;
    assign sum_temp = A + B + Cin;

    // Check if the sum exceeds 9 and perform BCD correction if necessary
    assign Sum = (sum_temp > 9) ? (sum_temp + 6) : sum_temp;
    assign Cout = (sum_temp > 9) ? 1'b1 : 1'b0;

    // Since Sum is a 4-bit output but the calculation can result in a 5-bit value,
    // we need to ensure that Sum only takes the 4 least significant bits of the result.
    // The Cout will handle any carry-out from the addition or correction.
    assign Sum = Sum[3:0];

endmodule