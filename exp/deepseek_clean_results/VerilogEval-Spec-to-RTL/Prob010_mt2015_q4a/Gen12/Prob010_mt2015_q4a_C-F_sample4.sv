module TopModule (
    input x,
    input y,
    output z
);
    assign z = x & ~y;  // Direct implementation of simplified boolean expression
endmodule