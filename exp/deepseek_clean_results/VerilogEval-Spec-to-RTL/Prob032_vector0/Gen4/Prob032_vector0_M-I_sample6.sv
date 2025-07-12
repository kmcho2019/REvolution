module TopModule (
    input [2:0] vec,       // 3-bit input vector
    output [2:0] outv,     // 3-bit vector output
    output o2,             // MSB of input vector
    output o1,             // Middle bit of input vector
    output o0              // LSB of input vector
);

    // Direct vector pass-through
    assign outv = vec;
    
    // Explicit bit extraction
    assign o2 = vec[2];    // Most significant bit
    assign o1 = vec[1];    // Middle bit
    assign o0 = vec[0];    // Least significant bit

endmodule