module TopModule(
    input  a,
    input  b,
    output out
);
    // Use equality comparison to implement XNOR functionality
    assign out = (a == b);
endmodule