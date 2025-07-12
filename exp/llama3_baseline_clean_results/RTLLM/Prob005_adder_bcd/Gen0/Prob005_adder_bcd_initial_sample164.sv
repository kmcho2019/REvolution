module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Perform binary addition of A, B, and Cin
    wire [4:0] bin_sum = A + B + Cin;

    // Check if the sum exceeds 9 and apply BCD correction
    assign Sum = (bin_sum > 9)? (bin_sum + 6)[3:0] : bin_sum[3:0];

    // Generate carry-out if the result exceeds 9
    assign Cout = (bin_sum > 9)? 1'b1 : 1'b0;

endmodule