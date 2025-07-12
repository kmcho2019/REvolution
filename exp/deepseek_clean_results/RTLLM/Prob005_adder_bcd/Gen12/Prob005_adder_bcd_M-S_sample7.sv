module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    wire [3:0] raw_sum = A + B + Cin;
    wire need_correction = (raw_sum > 9) || (A + B + Cin > 15);

    assign Sum = need_correction ? raw_sum + 6 : raw_sum;
    assign Cout = need_correction;

endmodule