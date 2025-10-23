module adder_bcd (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    // Direct calculation with inline correction
    assign {Cout, Sum} = (A + B + Cin) >= 10 ? 
                         {1'b1, (A + B + Cin + 6)} : 
                         {1'b0, (A + B + Cin)};

endmodule