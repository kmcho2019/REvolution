module TopModule (
    input [2:0] vec,
    output [2:0] outv,
    output o2, o1, o0
);

    // Combined assignment with explicit bit mapping
    assign {outv, o2, o1, o0} = {vec, vec[2], vec[1], vec[0]};
    // Bit positions: 
    // o2 = vec[2] (MSB)
    // o1 = vec[1]
    // o0 = vec[0] (LSB)

endmodule