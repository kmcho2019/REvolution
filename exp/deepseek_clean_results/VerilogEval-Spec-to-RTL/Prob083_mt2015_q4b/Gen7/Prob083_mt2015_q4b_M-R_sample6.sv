module TopModule (
    input x,
    input y,
    output z
);
    // Boolean implementation of XNOR
    assign z = (x & y) | (~x & ~y);
endmodule