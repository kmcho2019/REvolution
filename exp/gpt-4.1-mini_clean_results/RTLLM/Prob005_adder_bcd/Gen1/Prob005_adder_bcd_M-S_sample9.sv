module adder_bcd(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);

    wire [4:0] sum_bin;
    wire       add_six;
    wire [4:0] sum_corr;

    // 4-bit binary addition with carry
    assign sum_bin = {1'b0, A} + {1'b0, B} + Cin;

    // Check if sum > 9 (binary 1001) or if carry out from 4-bit addition is set
    assign add_six = (sum_bin[4] | (sum_bin[3] & (sum_bin[2] | sum_bin[1])));

    // Add 6 for BCD correction if needed
    assign sum_corr = add_six ? (sum_bin + 5'd6) : sum_bin;

    // Output corrected 4-bit sum
    assign Sum = sum_corr[3:0];

    // Carry out indicates sum exceeds one BCD digit
    assign Cout = sum_corr[4];

endmodule