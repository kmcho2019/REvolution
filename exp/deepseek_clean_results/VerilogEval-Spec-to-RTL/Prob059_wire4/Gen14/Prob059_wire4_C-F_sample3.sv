module TopModule (
    input  a,
    input  b,
    input  c,
    output w,
    output x,
    output y,
    output z
);
    // Direct wiring with grouped assignments
    assign {w} = a;
    assign {x, y} = {b, b};  // Group b connections
    assign {z} = c;
endmodule