module TopModule (
    input  a,     // 1-bit input a
    input  b,     // 1-bit input b
    output out    // 1-bit output: XNOR of a and b
);
    assign out = a ~^ b; // XNOR operation using Verilog's bitwise XNOR operator
endmodule