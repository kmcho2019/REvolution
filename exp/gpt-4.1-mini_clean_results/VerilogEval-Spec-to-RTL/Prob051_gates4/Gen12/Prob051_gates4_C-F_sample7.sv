module TopModule #(
    parameter WIDTH = 4
)(
    input  [WIDTH-1:0] in,
    output             out_and,
    output             out_or,
    output             out_xor
);

    // Combinational logic using Verilog reduction operators:
    // - out_and: AND of all bits in input vector
    // - out_or : OR  of all bits in input vector
    // - out_xor: XOR of all bits in input vector
    //
    // Parameter WIDTH allows easy scalability without code changes.
    // Outputs are wires driven by continuous assignments,
    // ensuring purely combinational, minimal-area, and minimal-power logic.

    assign out_and = &in;
    assign out_or  = |in;
    assign out_xor = ^in;

endmodule