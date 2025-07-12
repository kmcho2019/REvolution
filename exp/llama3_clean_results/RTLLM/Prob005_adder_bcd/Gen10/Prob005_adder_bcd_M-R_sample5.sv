module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Calculate the binary sum of A, B, and Cin
    wire [4:0] bin_sum;
    assign bin_sum = A + B + Cin;

    // Determine if the binary sum needs BCD correction
    wire needs_correction;
    assign needs_correction = (bin_sum > 9) || bin_sum[4];

    // Calculate the corrected sum if necessary
    wire [4:0] corrected_sum;
    assign corrected_sum = needs_correction? (bin_sum + 6) : bin_sum;

    // Assign Cout based on whether the original binary sum exceeded 9 or had a carry bit
    assign Cout = needs_correction;

    // Assign Sum by taking the lower 4 bits of the corrected sum
    assign Sum = corrected_sum[3:0];

endmodule