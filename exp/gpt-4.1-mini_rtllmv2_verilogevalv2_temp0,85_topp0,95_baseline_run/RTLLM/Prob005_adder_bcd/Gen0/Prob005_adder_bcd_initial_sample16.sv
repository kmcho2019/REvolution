module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);

    wire [4:0] raw_sum;
    wire       correction_needed;
    wire [4:0] corrected_sum;

    // Binary addition of A, B and Cin
    assign raw_sum = A + B + Cin;

    // Condition for BCD correction: sum > 9 or carry out from addition
    assign correction_needed = (raw_sum > 5'd9);

    // If correction is needed, add 6 to the raw sum
    assign corrected_sum = correction_needed ? (raw_sum + 5'd6) : raw_sum;

    // Output assignments
    assign Sum  = corrected_sum[3:0];
    assign Cout = corrected_sum[4];

endmodule