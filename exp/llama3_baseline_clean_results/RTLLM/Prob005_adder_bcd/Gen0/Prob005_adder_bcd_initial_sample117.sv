module adder_bcd(
    input  [3:0] A, // First BCD input
    input  [3:0] B, // Second BCD input
    input        Cin, // Carry-in input
    output [3:0] Sum, // 4-bit output representing the sum of the two BCD inputs
    output       Cout  // Carry-out output
);

    // Internal wire for sum before BCD correction
    wire [4:0] sum_before_correction;

    // Perform binary addition of A, B, and Cin
    assign sum_before_correction = A + B + Cin;

    // Generate carry-out (Cout) if the sum exceeds 9 (1001 in binary)
    assign Cout = (sum_before_correction > 9) ? 1'b1 : 1'b0;

    // Add 6 to the sum if it exceeds 9 to correct it to a valid BCD digit
    assign Sum = (sum_before_correction > 9) ? sum_before_correction + 6 : sum_before_correction;

endmodule