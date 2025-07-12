module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Directly calculate the binary sum
    wire [4:0] bin_sum = A + B + Cin;

    // Simplified BCD correction and carry generation
    assign Sum = bin_sum[3:0] + (bin_sum[4] ? 6 : 0);
    assign Cout = bin_sum[4];

endmodule