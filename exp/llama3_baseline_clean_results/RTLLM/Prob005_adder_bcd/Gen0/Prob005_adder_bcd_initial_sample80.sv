module adder_bcd(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);

    // Perform binary addition of A, B, and Cin
    wire [4:0] temp_sum = A + B + Cin;

    // Check if the sum exceeds 9 (binary 1001)
    assign Cout = (temp_sum > 9) ? 1'b1 : 1'b0;

    // Apply BCD correction by adding 6 if the sum exceeds 9
    assign Sum = (temp_sum > 9) ? (temp_sum + 6)[3:0] : temp_sum[3:0];

endmodule