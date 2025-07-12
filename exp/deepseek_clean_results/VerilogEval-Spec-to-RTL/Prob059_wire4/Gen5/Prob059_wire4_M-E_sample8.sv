module TopModule (
    input a,
    input b,
    input c,
    output w,
    output x,
    output y,
    output z
);
    // Implement wire connections using buffer logic (AND with 1'b1)
    and buf_w(w, a, 1'b1);
    and buf_x(x, b, 1'b1);
    and buf_y(y, b, 1'b1);
    and buf_z(z, c, 1'b1);
endmodule