module TopModule (
    input  [2:0] vec,
    output [2:0] outv,
    output       o2,
    output       o1,
    output       o0
);

    // Directly connect outputs to corresponding input bits
    assign o0 = vec[0];
    assign o1 = vec[1];
    assign o2 = vec[2];

    // Directly assign output vector to input vector
    assign outv = vec;

endmodule