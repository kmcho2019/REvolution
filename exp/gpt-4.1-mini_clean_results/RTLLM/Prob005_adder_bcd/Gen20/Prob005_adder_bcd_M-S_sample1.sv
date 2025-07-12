module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    wire [4:0] binary_sum;
    wire       correction_needed;
    wire [3:0] corrected_sum;

    // 4-bit binary addition plus carry-in
    assign binary_sum = A + B + Cin;

    // BCD correction needed if carry-out or sum > 9
    // sum > 9 detection using: sum[3] & (sum[2] | sum[1])
    assign correction_needed = binary_sum[4] | (binary_sum[3] & (binary_sum[2] | binary_sum[1]));

    // Add 6 if correction is needed (0110)
    assign corrected_sum = correction_needed ? (binary_sum[3:0] + 4'd6) : binary_sum[3:0];

    assign Sum  = corrected_sum;
    assign Cout = correction_needed;

endmodule