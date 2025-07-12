module TopModule (
    input [2:0] vec,       // 3-bit input vector
    output [2:0] outv,     // 3-bit output vector (direct copy)
    output o2, o1, o0      // Individual bit outputs
);

    // Vector output - direct assignment
    assign outv = vec;

    // Bit-position mapping:
    // o2 -> vec[2] (MSB)
    // o1 -> vec[1]
    // o0 -> vec[0] (LSB)
    assign {o2, o1, o0} = vec;

endmodule