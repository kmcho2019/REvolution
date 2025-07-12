module TopModule (
    input a,
    input b,
    input c,
    output w,
    output x,
    output y,
    output z
);
    // Refactored implementation using concatenated assignment
    assign {w, x, y, z} = {a, b, b, c};
endmodule