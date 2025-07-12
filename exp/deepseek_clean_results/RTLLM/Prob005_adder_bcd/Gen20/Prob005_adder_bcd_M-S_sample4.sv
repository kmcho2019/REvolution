module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    assign {Cout, Sum} = (A + B + Cin > 9) ? (A + B + Cin + 6) : (A + B + Cin);

endmodule