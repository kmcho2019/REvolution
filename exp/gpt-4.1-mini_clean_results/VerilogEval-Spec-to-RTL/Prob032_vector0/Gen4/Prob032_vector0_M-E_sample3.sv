module TopModule (
    input  [2:0] vec,
    output [2:0] outv,
    output       o2,
    output       o1,
    output       o0
);
    // Directly assign the output vector as the input vector
    assign outv = vec;

    // Map individual output bits directly from the input vector bits
    assign o0 = vec[0];
    assign o1 = vec[1];
    assign o2 = vec[2];

endmodule