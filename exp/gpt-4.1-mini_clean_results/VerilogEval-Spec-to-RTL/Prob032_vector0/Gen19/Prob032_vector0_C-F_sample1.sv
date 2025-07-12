module TopModule (
    input  [2:0] vec,
    output [2:0] outv,
    output       o2,
    output       o1,
    output       o0
);

    // Directly assign outv from vec for zero overhead
    assign outv = vec;

    // Assign each output bit directly from corresponding input bit for minimal area and power
    assign o0 = vec[0];
    assign o1 = vec[1];
    assign o2 = vec[2];

endmodule