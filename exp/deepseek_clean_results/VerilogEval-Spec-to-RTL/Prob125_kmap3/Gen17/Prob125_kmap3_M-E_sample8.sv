module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);
    // Hierarchical mux implementation
    assign out = c ? (a ? 1'b1 : ~b) : a;
endmodule