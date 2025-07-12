module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);

    wire [4:0] binary_sum;
    wire       correction_needed;
    wire [4:0] corrected_sum;

    // Binary addition of A, B and Cin
    assign binary_sum = A + B + Cin;

    // Determine if correction is needed (sum > 9 or carry out)
    assign correction_needed = (binary_sum[4] == 1'b1) || (binary_sum[3:0] > 4'd9);

    // Add 6 for BCD correction if needed
    assign corrected_sum = correction_needed ? (binary_sum + 5'd6) : binary_sum;

    // Outputs
    assign Sum  = corrected_sum[3:0];
    assign Cout = corrected_sum[4];

endmodule