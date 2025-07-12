module BitSplitter (
    input  [2:0] in_vec,
    output       o0,
    output       o1,
    output       o2
);
    // Direct assignments without intermediate signals or generate loops
    assign o0 = in_vec[0];
    assign o1 = in_vec[1];
    assign o2 = in_vec[2];
endmodule

module TopModule (
    input  [2:0] vec,
    output [2:0] outv,
    output       o2,
    output       o1,
    output       o0
);
    // Pass input vector directly to output vector for minimal logic
    assign outv = vec;

    // Instantiate streamlined BitSplitter for explicit bit extraction
    BitSplitter splitter (
        .in_vec(vec),
        .o0(o0),
        .o1(o1),
        .o2(o2)
    );

endmodule