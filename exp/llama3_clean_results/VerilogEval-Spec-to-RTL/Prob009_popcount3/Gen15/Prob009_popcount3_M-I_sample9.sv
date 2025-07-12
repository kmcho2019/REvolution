module TopModule(
    input [2:0] in,
    output [1:0] out
);

    // Implement the population count logic using a more efficient approach
    // that minimizes switching activity for better power efficiency
    wire [1:0] count;
    assign count = (in[0] + in[1] + in[2]);

    // Directly assign the count to the output, ensuring simplicity and low latency
    assign out = count;

    // Consider adding synthesis directives or attributes to optimize for the target technology
    // This could involve optimizing for area, power, or performance based on the design's requirements

endmodule