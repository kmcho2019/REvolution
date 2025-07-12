module TopModule (
    input  [2:0] vec,
    output [2:0] outv,
    output       o2,
    output       o1,
    output       o0
);
    // Directly assign the outv output as the same vector as input vec
    assign outv = vec;

    // Assign individual bit outputs directly from vec
    assign o0 = vec[0];
    assign o1 = vec[1];
    assign o2 = vec[2];

endmodule