module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Directly compute the binary sum of A, B, and Cin
    wire [4:0] bin_sum = A + B + Cin;

    // Generate Cout based on whether bin_sum exceeds 9 or has a carry bit
    assign Cout = (bin_sum > 9) | bin_sum[4];

    // Calculate Sum with BCD correction in a single step
    assign Sum = (bin_sum <= 9) ? bin_sum[3:0] : ((bin_sum[3:0] + 4'd6) & 4'd15);

endmodule