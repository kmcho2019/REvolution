module TopModule(
    input  [2:0] vec,  // 3-bit input vector
    output [2:0] outv, // 3-bit output vector
    output       o2,  // 1-bit output connected to vec[2]
    output       o1,  // 1-bit output connected to vec[1]
    output       o0   // 1-bit output connected to vec[0]
);

    assign outv = vec;  // Direct assignment of input vector to output vector
    assign o2   = vec[2]; // Assign bit 2 of vec to o2
    assign o1   = vec[1]; // Assign bit 1 of vec to o1
    assign o0   = vec[0]; // Assign bit 0 of vec to o0

endmodule