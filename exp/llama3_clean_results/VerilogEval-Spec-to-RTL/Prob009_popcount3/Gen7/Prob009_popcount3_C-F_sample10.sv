module TopModule(
    input [2:0] in,
    output [1:0] out
);

    // Directly implement the population count logic using addition
    // This approach is straightforward and optimized for small input vectors
    assign out = {1'b0, in[0]} + {1'b0, in[1]} + {1'b0, in[2]};

    // Alternatively, consider using specific synthesis directives or attributes
    // to further optimize the design for the target technology
    // This could involve optimizing for area, power, or performance based on the design's requirements

endmodule