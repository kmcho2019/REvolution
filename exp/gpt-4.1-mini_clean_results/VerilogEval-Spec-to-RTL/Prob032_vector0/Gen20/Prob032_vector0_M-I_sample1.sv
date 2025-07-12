module TopModule (
    input  [2:0] vec,
    output [2:0] outv,
    output       o2,
    output       o1,
    output       o0
);

    // Directly propagate the input vector to output outv for zero overhead
    assign outv = vec;

    // Split input vector bits to individual outputs:
    // o0 corresponds to vec[0]
    // o1 corresponds to vec[1]
    // o2 corresponds to vec[2]
    assign o0 = vec[0];
    assign o1 = vec[1];
    assign o2 = vec[2];

endmodule