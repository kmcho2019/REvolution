module TopModule (
    input x,
    input y,
    output z
);
    // Mux-based implementation of z = (x^y) & x
    // When x=0: z=0
    // When x=1: z=~y
    // Mathematically equivalent to x & ~y
    assign z = x ? ~y : 1'b0;
endmodule