// TopModule: A module that takes a 3-bit input vector, outputs the same vector, 
// and splits it into three separate 1-bit outputs.
module TopModule(
    // 3-bit input vector
    input [2:0] vec,
    // 3-bit output vector
    output [2:0] outv,
    // 1-bit output corresponding to the most significant bit of vec
    output o2,
    // 1-bit output corresponding to the middle bit of vec
    output o1,
    // 1-bit output corresponding to the least significant bit of vec
    output o0
    );
    
    // Directly assign the input vector to the output vector for efficiency
    assign outv = vec;
    
    // Assign individual bits of the input vector to the single-bit outputs
    // This approach minimizes unnecessary signal switching and maintains performance
    assign o2 = vec[2];
    assign o1 = vec[1];
    assign o0 = vec[0];

endmodule