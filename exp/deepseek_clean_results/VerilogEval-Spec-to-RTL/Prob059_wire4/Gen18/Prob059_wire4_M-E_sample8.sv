module TopModule (
    input  a,
    input  b,
    input  c,
    output w,
    output x,
    output y,
    output z
);
    // Using AND gates as buffers (AND with 1'b1 is equivalent to a wire)
    and(w, a, 1'b1);
    and(x, b, 1'b1);
    and(y, b, 1'b1);
    and(z, c, 1'b1);
endmodule