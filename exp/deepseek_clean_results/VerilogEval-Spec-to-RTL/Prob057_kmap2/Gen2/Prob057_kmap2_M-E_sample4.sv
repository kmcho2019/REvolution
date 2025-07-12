module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

    // Hierarchical multiplexer implementation
    assign out = d ? (c ? (a | b) : (~a | ~b))  // d=1 cases
                  : (c ? (~a | b) : (~a | ~b)); // d=0 cases

endmodule