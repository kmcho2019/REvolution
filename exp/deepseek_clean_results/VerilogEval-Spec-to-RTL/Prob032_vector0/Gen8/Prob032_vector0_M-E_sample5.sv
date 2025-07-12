module TopModule (
    input [2:0] vec,
    output [2:0] outv,
    output o2,
    output o1,
    output o0
);

    // Use buffer gates for explicit bit connections
    buf b0(o0, vec[0]);
    buf b1(o1, vec[1]);
    buf b2(o2, vec[2]);
    
    // Buffer the entire vector output
    buf bv0(outv[0], vec[0]);
    buf bv1(outv[1], vec[1]);
    buf bv2(outv[2], vec[2]);

endmodule