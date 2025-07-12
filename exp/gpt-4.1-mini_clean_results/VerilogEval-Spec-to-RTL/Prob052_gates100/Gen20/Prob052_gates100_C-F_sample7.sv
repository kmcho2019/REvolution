module TopModule (
    input  [99:0] in,
    output        out_and,  // AND reduction of all 100 inputs
    output        out_or,   // OR reduction of all 100 inputs
    output        out_xor   // XOR (parity) reduction of all 100 inputs
);

    // Use built-in Verilog reduction operators for optimized combinational logic
    assign out_and = &in;
    assign out_or  = |in;
    assign out_xor = ^in;

endmodule