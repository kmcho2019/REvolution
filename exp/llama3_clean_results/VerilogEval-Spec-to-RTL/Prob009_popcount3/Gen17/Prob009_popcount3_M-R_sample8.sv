module TopModule(
    input [2:0] in,
    output [1:0] out
);

    // Directly calculate the population count without intermediate wires
    assign out = in[0] + in[1] + in[2];

    // Consider adding synthesis directives or attributes as needed
    // to optimize the design for the target technology

endmodule