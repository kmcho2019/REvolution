module adder_bcd(
    input  [3:0] A,    // First BCD input
    input  [3:0] B,    // Second BCD input
    input        Cin,  // Carry-in input
    output [3:0] Sum,  // 4-bit output representing the sum of A and B
    output       Cout  // Carry-out output
);

    // Temporary variable to store the sum of A, B, and Cin
    wire [4:0] temp_sum;

    // Perform binary addition
    assign temp_sum = A + B + Cin;

    // If the sum exceeds 9, perform BCD correction and generate carry-out
    assign Sum = (temp_sum > 9)? (temp_sum + 6)[3:0] : temp_sum[3:0];
    assign Cout = (temp_sum > 9)? 1'b1 : 1'b0;

endmodule