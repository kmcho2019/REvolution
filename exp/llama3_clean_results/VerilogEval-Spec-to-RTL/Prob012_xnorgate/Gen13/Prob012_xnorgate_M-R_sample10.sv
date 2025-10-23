module TopModule(
    input  a,
    input  b,
    output out
);

    // Refactored XNOR implementation using equality operator
    assign out = (a == b);

endmodule