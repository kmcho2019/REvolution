module TopModule (
    input  [2:0] vec,
    output [2:0] outv,
    output       o2,
    output       o1,
    output       o0
);
    // Directly connect output vector
    assign outv = vec;

    // Directly assign individual output bits from input vector
    assign o0 = vec[0];
    assign o1 = vec[1];
    assign o2 = vec[2];

endmodule