module TopModule (
    input x,
    input y,
    output z
);
    assign z = (x & y) | (~x & ~y);  // Direct implementation of XNOR
endmodule