module TopModule(
    input [2:0] in,
    output [1:0] out
);

    assign out = in[0] + in[1] + in[2];

    // This simplified implementation maintains the direct arithmetic approach but reduces the expression complexity.
    // It directly calculates the population count of the input vector 'in' and assigns it to 'out'.

endmodule