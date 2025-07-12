module TopModule (
    input a,
    input b,
    output out
);
    // Direct mux-based XNOR implementation without intermediate wire
    assign out = b ? a : ~a;
endmodule