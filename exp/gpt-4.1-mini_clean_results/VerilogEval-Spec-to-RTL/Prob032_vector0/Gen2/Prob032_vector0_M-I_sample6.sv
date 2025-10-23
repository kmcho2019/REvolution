module TopModule(
    input  [2:0] vec,
    output [2:0] outv,
    output       o2,
    output       o1,
    output       o0
);

    // Directly assign output vector
    assign outv = vec;

    // Connect single-bit outputs as slices of the input vector
    wire [2:0] vec_wire = vec;
    assign {o2, o1, o0} = vec_wire;

endmodule