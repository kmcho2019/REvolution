module adder_bcd (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);
    wire [4:0] sum_bin = A + B + Cin;
    wire correction = (sum_bin > 5'd9);
    wire [4:0] sum_corr = correction ? (sum_bin + 5'd6) : sum_bin;

    assign Sum  = sum_corr[3:0];
    assign Cout = sum_corr[4];

endmodule