module TopModule (
    input a,
    input b,
    output out
);
    // MUX-based XNOR implementation
    // When a=0: out = b (XNOR false case)
    // When a=1: out = ~b (XNOR true case)
    assign out = a ? ~b : b;
endmodule