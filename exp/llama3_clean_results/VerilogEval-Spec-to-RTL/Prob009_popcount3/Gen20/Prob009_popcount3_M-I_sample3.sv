module TopModule(
    input [2:0] in,
    output [1:0] out
);

    // Directly implement the population count logic
    // This approach maintains simplicity and is optimized for small input vectors
    assign out[0] = in[0] ^ in[1] ^ in[2]; // Least significant bit
    assign out[1] = (in[0] & in[1]) | (in[0] & in[2]) | (in[1] & in[2]); // Most significant bit

    // Consider using specific synthesis directives or attributes
    // to further optimize the design for the target technology
    // This could involve optimizing for area, power, or performance based on the design's requirements

endmodule