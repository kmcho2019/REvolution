module TopModule (
    input a,
    input b,
    input c,
    output w,
    output x,
    output y,
    output z
);
    // Single assign with explicit bit mapping
    assign {w, x, y, z} = {a, b, b, c};
endmodule