module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Calculate the binary sum of A, B, and Cin
    wire [4:0] bin_sum = A + B + Cin;

    // Assign Cout directly based on bin_sum exceeding 9 or having a carry bit
    assign Cout = (bin_sum > 9) || bin_sum[4];

    // Calculate the corrected sum in a single step, applying BCD correction if necessary
    wire [4:0] corrected_sum = Cout ? (bin_sum + 6) : bin_sum;

    // Assign Sum by taking the lower 4 bits of the corrected sum
    assign Sum = corrected_sum[3:0];

endmodule