module TopModule (
    input x,
    input y,
    output z
);
    assign z = (x ^ y) & x;
    // Equivalent to: assign z = x & ~y;
endmodule