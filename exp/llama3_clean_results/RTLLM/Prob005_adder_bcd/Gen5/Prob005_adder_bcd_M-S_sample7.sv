module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Calculate the binary sum of A, B, and Cin
    wire [4:0] bin_sum = A + B + Cin;

    // Apply BCD correction and generate Cout in a single step
    assign Sum = bin_sum[3:0] + (bin_sum > 9 ? 4'd6 : 4'd0);
    assign Cout = bin_sum[4] || (bin_sum > 9 && bin_sum[3:0] + 4'd6 > 9);

endmodule