module adder_bcd(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);

    wire [4:0] binary_sum = A + B + Cin;  // 5-bit sum to detect overflow
    wire       correction_needed = (binary_sum > 5'd9);
    wire [4:0] corrected_sum = correction_needed ? (binary_sum + 5'd6) : binary_sum;

    assign Sum  = corrected_sum[3:0];
    assign Cout = corrected_sum[4];

endmodule