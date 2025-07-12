// TopModule: This module takes a 3-bit input vector, assigns it directly to a 3-bit output vector,
// and splits the input vector into three separate 1-bit outputs.
module TopModule(
    input [2:0] vec,  // 3-bit input vector
    output [2:0] outv,  // 3-bit output vector
    output o2,  // Most significant bit of the input vector
    output o1,  // Middle bit of the input vector
    output o0   // Least significant bit of the input vector
    );
    
    // Directly assign the input vector to the output vector
    assign outv = vec;
    
    // Split the input vector into separate 1-bit outputs
    // Note: Verilog uses 0-indexing, so vec[2] is the most significant bit, vec[1] the middle, and vec[0] the least significant.
    assign o2 = vec[2];  // Most significant bit
    assign o1 = vec[1];  // Middle bit
    assign o0 = vec[0];  // Least significant bit

endmodule