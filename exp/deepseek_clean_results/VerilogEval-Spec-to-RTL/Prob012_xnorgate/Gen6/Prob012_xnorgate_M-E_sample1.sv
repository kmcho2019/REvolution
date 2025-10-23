module TopModule (
    input a,
    input b,
    output out
);
    // MUX-based XNOR implementation
    assign out = b ? ~a : a;
endmodule