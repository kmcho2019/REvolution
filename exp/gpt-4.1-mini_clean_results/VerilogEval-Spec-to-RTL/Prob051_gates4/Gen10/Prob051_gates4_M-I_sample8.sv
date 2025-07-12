module TopModule #(
    parameter WIDTH = 4
)(
    input  [WIDTH-1:0] in,
    output             out_and,
    output             out_or,
    output             out_xor
);

    // Combinational logic using Verilog reduction operators:
    // - out_and: logical AND of all bits in input vector
    // - out_or : logical OR  of all bits in input vector
    // - out_xor: logical XOR of all bits in input vector
    //
    // Parameter WIDTH allows future scalability without redesign.
    // The outputs are wires driven by continuous assignment,
    // ensuring purely combinational, minimal-area logic.

    assign out_and = &in;
    assign out_or  = |in;
    assign out_xor = ^in;

endmodule