module adder_bcd(
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    wire [4:0] sum_raw = A + B + Cin;
    wire       corr = (sum_raw > 5'd9);
    wire [4:0] sum_corr = sum_raw + (corr ? 5'd6 : 5'd0);

    assign Sum = sum_corr[3:0];
    assign Cout = sum_corr[4];

endmodule