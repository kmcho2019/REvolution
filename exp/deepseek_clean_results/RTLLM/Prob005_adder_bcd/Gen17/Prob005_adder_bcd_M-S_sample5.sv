module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Combined sum with conditional correction in one expression
    assign {Cout, Sum} = A + B + Cin + ((A + B + Cin > 9) ? 5'd6 : 5'd0);

endmodule