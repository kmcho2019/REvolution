module TopModule(
    input [2:0] vec,
    output [2:0] outv,
    output o2,
    output o1,
    output o0
    );
    
    // Directly assign the input vector to the output vector for efficiency
    // Consider synthesis directives for optimization
    assign outv = vec;
    
    // Assign individual bits of the input vector to the single-bit outputs
    // This approach minimizes unnecessary signal switching and maintains performance
    // Ensure the logic is implemented in an area-efficient manner
    assign o2 = vec[2];
    assign o1 = vec[1];
    assign o0 = vec[0];

endmodule