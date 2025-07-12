module TopModule (
    input a,
    input b,
    output out
);
    // Mux-based XNOR implementation
    // When a=0, select b (out = b)
    // When a=1, select ~b (out = ~b)
    // This is equivalent to XNOR functionality
    assign out = a ? ~b : b;
endmodule