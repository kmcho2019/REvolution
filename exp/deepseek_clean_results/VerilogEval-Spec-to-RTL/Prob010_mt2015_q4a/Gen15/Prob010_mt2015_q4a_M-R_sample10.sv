module TopModule (
    input x,
    input y,
    output z
);
    assign z = x & ~y;  // Direct implementation of the simplified boolean expression
endmodule