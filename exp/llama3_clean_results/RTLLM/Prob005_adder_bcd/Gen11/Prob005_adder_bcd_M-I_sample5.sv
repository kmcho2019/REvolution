module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Directly compute the binary sum of A, B, and Cin
    wire [4:0] bin_sum = A + B + Cin;

    // Simplify Cout calculation
    assign Cout = bin_sum[4]; // If bin_sum > 9, it will have a carry bit

    // Maintain the conditional operator for Sum calculation but ensure it's optimized
    assign Sum = (bin_sum <= 9)? bin_sum[3:0] : (bin_sum[3:0] + 4'd6);

endmodule