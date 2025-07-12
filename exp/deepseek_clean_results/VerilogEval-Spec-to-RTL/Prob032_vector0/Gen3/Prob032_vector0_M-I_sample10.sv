module TopModule (
    input [2:0] vec,
    output [2:0] outv,
    output o2,
    output o1,
    output o0
);

    // Single assignment for all outputs
    assign {outv, o2, o1, o0} = {vec, vec};

endmodule