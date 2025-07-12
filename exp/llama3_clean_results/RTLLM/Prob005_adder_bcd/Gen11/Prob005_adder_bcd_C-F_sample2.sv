module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Perform binary addition directly
    wire [4:0] bin_sum = A + B + Cin;

    // Generate Cout based on whether bin_sum exceeds 9 or has a carry bit
    assign Cout = (bin_sum > 9) | bin_sum[4];

    // Calculate Sum with BCD correction in a single step, using the direct approach
    assign Sum = Cout ? (bin_sum[3:0] + 4'd6) : bin_sum[3:0];

endmodule