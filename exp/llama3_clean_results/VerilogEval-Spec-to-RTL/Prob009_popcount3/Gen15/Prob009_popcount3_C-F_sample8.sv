module TopModule(
    input [2:0] in,
    output [1:0] out
);

    // Directly implement the population count logic using addition
    // This approach is straightforward and optimized for small input vectors
    assign out = in[0] + in[1] + in[2];

    // Consider adding synthesis directives or attributes as needed
    // to optimize the design for the target technology
    // For example, using specific attributes to optimize for area or power
    // could further improve the PPA metrics of the design

endmodule