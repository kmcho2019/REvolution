module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Directly calculate the binary sum
    wire [4:0] bin_sum = A + B + Cin;

    // Apply BCD correction if the sum exceeds 9 and generate carry-out
    assign Sum = (bin_sum > 9)? (bin_sum[3:0] + 6) : bin_sum[3:0];
    assign Cout = (bin_sum > 9);

endmodule