module TopModule (
    input a,
    input b,
    input c,
    output w,
    output x,
    output y,
    output z
);
    // Group all wire assignments together
    assign {w, x, y, z} = {a, b, b, c};
endmodule