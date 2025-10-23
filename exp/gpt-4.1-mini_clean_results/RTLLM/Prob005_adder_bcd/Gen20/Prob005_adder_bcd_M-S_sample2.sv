module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    wire [4:0] sum_raw;
    wire       corr;

    // 5-bit addition: A + B + Cin
    assign sum_raw = {1'b0, A} + {1'b0, B} + Cin;

    // Correction needed if sum_raw > 9:
    // sum_raw > 9 when sum_raw[4] == 1 OR (sum_raw[3] & (sum_raw[2] | sum_raw[1]))
    // This is a minimal logic for detecting sum > 9 in 5-bit sum
    assign corr = sum_raw[4] | (sum_raw[3] & (sum_raw[2] | sum_raw[1]));

    // Add 6 (0110) when correction needed, else 0
    wire [4:0] sum_corr = sum_raw + (corr ? 5'd6 : 5'd0);

    // Output corrected sum and carry out
    assign Sum  = sum_corr[3:0];
    assign Cout = corr;

endmodule