module TopModule(
    input [2:0] in,
    output [1:0] out
);

    // The current implementation is already efficient.
    // For further optimization, consider technology-specific attributes or directives during synthesis.
    assign out = in[0] + in[1] + in[2];

endmodule