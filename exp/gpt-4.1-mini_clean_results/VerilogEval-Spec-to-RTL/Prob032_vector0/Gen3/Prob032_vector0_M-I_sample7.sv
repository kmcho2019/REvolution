module TopModule(
    input  [2:0] vec,
    output [2:0] outv,
    output       o2,
    output       o1,
    output       o0
);

    // Directly assign output vector
    assign outv = vec;

    // Directly assign single-bit outputs from input vector bits
    assign {o2, o1, o0} = vec;

endmodule