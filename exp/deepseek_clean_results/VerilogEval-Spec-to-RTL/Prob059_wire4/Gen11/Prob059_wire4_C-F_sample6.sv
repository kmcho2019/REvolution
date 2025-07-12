module TopModule (
    input a,
    input b,
    input c,
    output w,
    output x,
    output y,
    output z
);
    // Direct wire connections using concatenation
    assign {w, x, y, z} = {a, b, b, c};
endmodule