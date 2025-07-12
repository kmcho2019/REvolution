module TopModule (
    input a,
    input b,
    input c,
    output w,
    output x,
    output y,
    output z
);
    assign {w, z} = {a, c};
    assign {x, y} = {b, b};
endmodule