module TopModule (
    input a,
    input b,
    input c,
    output w,
    output x,
    output y,
    output z
);
    assign w = a;
    assign {x, y} = {b, b};  // Combined assignment for x and y
    assign z = c;
endmodule