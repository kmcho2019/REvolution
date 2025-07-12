// Improved version of TopModule, focusing on best practices for coding style and documentation
module TopModule(
    // 3-bit input vector
    input  [2:0] vec,
    // 3-bit output vector
    output [2:0] outv,
    // Individual bit outputs
    output       o2,
    output       o1,
    output       o0
    );

    // Directly assign the input vector to the output vector
    assign outv = vec;
    
    // Split the input vector into individual bits
    assign o2 = vec[2]; // MSB
    assign o1 = vec[1];
    assign o0 = vec[0]; // LSB

endmodule