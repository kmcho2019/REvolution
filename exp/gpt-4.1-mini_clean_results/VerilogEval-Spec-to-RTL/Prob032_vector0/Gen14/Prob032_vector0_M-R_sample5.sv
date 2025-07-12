module TopModule (
    input  [2:0] vec,
    output [2:0] outv,
    output       o2,
    output       o1,
    output       o0
);
    // Direct bit slicing assignments without extra module
    assign o0 = vec[0];
    assign o1 = vec[1];
    assign o2 = vec[2];

    // Pass input vector directly to output vector
    assign outv = vec;

endmodule