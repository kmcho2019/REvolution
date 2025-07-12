module TopModule(
    input [2:0] in,
    output [1:0] out
);

    // Use a dedicated population count circuit to optimize for area and power
    wire [1:0] count;
    assign count[0] = in[0] ^ in[1] ^ in[2];
    assign count[1] = (in[0] & in[1]) | (in[0] & in[2]) | (in[1] & in[2]);

    // Directly assign the count to the output, ensuring simplicity and low latency
    assign out = count;

    // Consider adding synthesis directives or attributes to optimize for the target technology
    // This could involve optimizing for area, power, or performance based on the design's requirements
    // For example, we can use the following directive to optimize for area
    // (* area_optimization = "high" *)

endmodule