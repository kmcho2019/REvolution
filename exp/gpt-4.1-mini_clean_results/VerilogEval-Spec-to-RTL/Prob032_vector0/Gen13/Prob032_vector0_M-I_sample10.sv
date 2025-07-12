module TopModule (
    input  [2:0] vec,
    output [2:0] outv,
    output       o2,
    output       o1,
    output       o0
);
    // Directly assign output vector
    assign outv = vec;

    // Directly split bits to individual outputs to avoid module overhead
    assign o0 = vec[0];
    assign o1 = vec[1];
    assign o2 = vec[2];

endmodule