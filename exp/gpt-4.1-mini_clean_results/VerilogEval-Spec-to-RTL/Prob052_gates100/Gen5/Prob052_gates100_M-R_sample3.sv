module TopModule (
    input  [99:0] in,
    output        out_and,  // 100-input AND
    output        out_or,   // 100-input OR
    output        out_xor   // 100-input XOR (parity)
);

    // Use Verilog built-in reduction operators directly for combinational outputs
    assign out_and = &in;   // reduction AND: 1 if all bits in 'in' are 1
    assign out_or  = |in;   // reduction OR:  1 if any bit in 'in' is 1
    assign out_xor = ^in;   // reduction XOR: parity of all bits in 'in'

endmodule