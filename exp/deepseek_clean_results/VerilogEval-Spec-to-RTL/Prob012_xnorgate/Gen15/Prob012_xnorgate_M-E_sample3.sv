module TopModule (
    input a,
    input b,
    output out
);
    // Mux-based XNOR implementation
    // out = (a == b) ? 1 : 0
    // Implemented as: b ? a : ~a
    wire a_inv;
    
    assign a_inv = ~a;
    assign out = b ? a : a_inv;
endmodule