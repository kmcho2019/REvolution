module adder_bcd(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);

    wire [4:0] sum_raw;  // 5-bit to include carry-out
    wire       correction_needed;
    wire [4:0] sum_corr;

    // 4-bit addition with carry-out
    assign sum_raw = {1'b0, A} + {1'b0, B} + Cin;

    // Correction needed if sum > 9 or carry-out is set
    assign correction_needed = (sum_raw[4] == 1'b1) || (sum_raw[3:0] > 4'd9);

    // Add 6 if correction needed
    assign sum_corr = correction_needed ? (sum_raw + 5'd6) : sum_raw;

    assign Sum  = sum_corr[3:0];
    assign Cout = sum_corr[4];

endmodule