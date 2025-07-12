module TopModule(
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Directly assign the result of AND, OR, and XOR operations to output ports
    assign out_and = &in; // Reduction AND across all bits of in
    assign out_or  = |in;  // Reduction OR across all bits of in
    assign out_xor = ^in;  // Reduction XOR across all bits of in

endmodule