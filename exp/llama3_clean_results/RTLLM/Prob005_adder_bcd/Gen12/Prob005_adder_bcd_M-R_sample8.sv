module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Directly compute the binary sum of A, B, and Cin
    wire [4:0] bin_sum = A + B + Cin;

    // Determine if BCD correction is needed
    wire needs_correction = (bin_sum > 9);

    // Calculate the corrected sum
    wire [3:0] corrected_sum = needs_correction? (bin_sum[3:0] + 4'd6) : bin_sum[3:0];

    // Assign Sum and Cout based on the corrected sum and the need for correction
    assign Sum = corrected_sum;
    assign Cout = needs_correction;

endmodule