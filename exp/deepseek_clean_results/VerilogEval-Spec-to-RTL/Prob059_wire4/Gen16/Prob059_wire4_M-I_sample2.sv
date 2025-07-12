module TopModule (
    input a,
    input b,
    input c,
    output w,
    output x,
    output y,
    output z
);
    // Combined direct wire connections for cleaner code
    assign {w, x, y, z} = {a, b, b, c};
endmodule