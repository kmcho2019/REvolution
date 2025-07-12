// Mux-based XNOR gate implementation
module TopModule (
    input a,
    input b,
    output out
);
    // Use a 2:1 mux to implement XNOR
    // When a=0, select b (out = b)
    // When a=1, select ~b (out = ~b)
    assign out = a ? ~b : b;
endmodule