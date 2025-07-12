module TopModule (
    input  [99:0] in,
    output        out_and,  // 100-input AND
    output        out_or,   // 100-input OR
    output        out_xor   // 100-input XOR (parity)
);

    // Use built-in Verilog reduction operators for optimal synthesis
    assign out_and = &in;
    assign out_or  = |in;
    assign out_xor = ^in;

endmodule