module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Calculate the binary sum of A, B, and Cin
    wire [4:0] bin_sum = A + B + Cin;

    // Generate Cout based on whether bin_sum exceeds 9
    assign Cout = bin_sum[4];

    // Apply BCD correction to calculate Sum
    assign Sum = (Cout) ? (bin_sum[3:0] + 4'd6) : bin_sum[3:0];

endmodule