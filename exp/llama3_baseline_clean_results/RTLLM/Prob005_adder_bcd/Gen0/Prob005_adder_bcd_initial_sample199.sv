module adder_bcd(
    input  [3:0] A,
    input  [3:0] B,
    input       Cin,
    output [3:0] Sum,
    output       Cout
);

    // Perform binary addition of A, B, and Cin
    wire [4:0] temp_sum = A + B + Cin;

    // Apply BCD correction if sum exceeds 9
    assign Sum = (temp_sum > 9) ? (temp_sum + 6) : temp_sum[3:0];

    // Generate carry-out if result exceeds 9
    assign Cout = (temp_sum > 9) ? 1'b1 : 1'b0;

endmodule