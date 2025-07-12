module TopModule #(
    parameter WIDTH = 4
)(
    input  [WIDTH-1:0] in,
    output             out_and,
    output             out_or,
    output             out_xor
);

    // Outputs are combinational reductions of the input vector:
    // - out_and: logical AND of all input bits
    // - out_or : logical OR  of all input bits
    // - out_xor: logical XOR of all input bits
    //
    // Parameter WIDTH enables scalability for different input sizes.
    // Continuous assignments with reduction operators produce 
    // minimal-area, low-power combinational logic.

    assign out_and = &in;
    assign out_or  = |in;
    assign out_xor = ^in;

endmodule