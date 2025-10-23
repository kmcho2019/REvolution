module TopModule (
    input a,
    input b,
    output out
);
    // Implement XNOR using multiplexer logic
    assign out = b ? ~a : a;
endmodule