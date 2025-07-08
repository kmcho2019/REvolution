module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);

    wire [4:0] binary_sum;      // 5-bit sum to include possible carry
    wire [4:0] corrected_sum;   // sum after BCD correction
    wire       correction_needed;

    // Perform binary addition
    assign binary_sum = A + B + Cin;

    // Determine if correction is needed: sum > 9
    assign correction_needed = (binary_sum > 5'd9);

    // Add 6 if correction is needed
    assign corrected_sum = correction_needed ? (binary_sum + 5'd6) : binary_sum;

    // Assign outputs
    assign Sum  = corrected_sum[3:0];
    assign Cout = corrected_sum[4];

endmodule