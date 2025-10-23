module TopModule (
    input a,
    input b,
    output out
);
    // Mux-based XNOR implementation
    assign out = a ? b : ~b;
endmodule