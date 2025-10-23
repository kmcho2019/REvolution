module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Perform binary addition directly
    wire [4:0] bin_sum = A + B + Cin;

    // Determine Cout based on bin_sum exceeding 9 or having a carry bit
    assign Cout = (bin_sum > 9) || bin_sum[4];

    // Calculate the corrected sum in a single step, applying BCD correction if necessary
    assign Sum = (Cout)? (bin_sum[3:0] + 6) : bin_sum[3:0];

endmodule