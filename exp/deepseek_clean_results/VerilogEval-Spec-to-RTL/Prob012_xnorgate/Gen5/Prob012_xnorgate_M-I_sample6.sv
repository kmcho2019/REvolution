module TopModule (
    input a,
    input b,
    output out
);
    // Implement XNOR as a multiplexer:
    // When b=0, select ~a
    // When b=1, select a
    assign out = b ? a : ~a;
endmodule