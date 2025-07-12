module TopModule (
    input [2:0] vec,
    output [2:0] outv,
    output o2, o1, o0
);

    // Direct bit connections - no intermediate assignments
    assign {o2, o1, o0} = vec;
    assign outv = vec;  // Keep vector output for completeness

endmodule