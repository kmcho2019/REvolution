module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Perform binary addition of A, B, and Cin
    wire [4:0] bin_sum = A + B + Cin;

    // Assign Sum directly with BCD correction and generate Cout
    assign Sum = (bin_sum <= 9) ? bin_sum[3:0] : (bin_sum[3:0] + 4'd6);
    assign Cout = (bin_sum > 9) | bin_sum[4];

endmodule