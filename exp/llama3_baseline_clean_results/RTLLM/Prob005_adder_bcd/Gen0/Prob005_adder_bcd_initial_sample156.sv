module adder_bcd(
    input  [3:0] A,  // First BCD input
    input  [3:0] B,  // Second BCD input
    input        Cin,  // Carry-in input
    output [3:0] Sum,  // 4-bit output representing the BCD sum
    output       Cout   // Carry-out output
);

    // Perform binary addition of A, B, and Cin
    reg [4:0] sum_binary;
    assign sum_binary = A + B + Cin;

    // Apply BCD correction if sum exceeds 9
    reg [4:0] sum_corrected;
    assign sum_corrected = (sum_binary > 9)? sum_binary + 6 : sum_binary;

    // Generate carry-out if sum exceeds 9
    assign Cout = (sum_binary > 9)? 1'b1 : 1'b0;

    // Assign the corrected sum to the output, truncating the most significant bit
    assign Sum = sum_corrected[3:0];

endmodule