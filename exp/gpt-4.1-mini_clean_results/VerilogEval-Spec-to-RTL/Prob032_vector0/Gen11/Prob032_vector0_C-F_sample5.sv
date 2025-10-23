module TopModule (
    input  [2:0] vec,
    output [2:0] outv,
    output       o2,
    output       o1,
    output       o0
);

    // Directly assign output vector from input vector to avoid redundant logic
    assign outv = vec;

    // Explicitly split input vector bits to individual outputs to ensure clarity and minimal overhead
    assign o0 = vec[0];
    assign o1 = vec[1];
    assign o2 = vec[2];

endmodule