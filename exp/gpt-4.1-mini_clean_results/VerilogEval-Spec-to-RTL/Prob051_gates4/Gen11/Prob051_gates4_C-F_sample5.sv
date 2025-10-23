module TopModule #(
    parameter WIDTH = 4
)(
    input  wire [WIDTH-1:0] in,
    output wire             out_and,
    output wire             out_or,
    output wire             out_xor
);

    // Combinational logic using Verilog reduction operators:
    // - out_and: logical AND of all bits in input vector 'in'
    // - out_or : logical OR  of all bits in input vector 'in'
    // - out_xor: logical XOR of all bits in input vector 'in'
    //
    // Parameter WIDTH allows flexibility for wider inputs in the future.
    // The outputs are wires driven by continuous assignments,
    // ensuring purely combinational minimal-area logic.
    //
    // Synthesis attribute 'keep' hints to preserve these signals
    // during optimization for debugging or tool-specific needs.
    // Remove if not needed in your synthesis flow.

    (* keep = "true" *) assign out_and = &in;
    (* keep = "true" *) assign out_or  = |in;
    (* keep = "true" *) assign out_xor = ^in;

endmodule