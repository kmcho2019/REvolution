module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Directly compute the binary sum of A, B, and Cin
    wire [4:0] bin_sum = A + B + Cin;

    // Use conditional operator to concisely calculate Sum and Cout
    assign Sum = (bin_sum > 9) ? (bin_sum + 6)[3:0] : bin_sum[3:0];
    assign Cout = (bin_sum > 9);

endmodule