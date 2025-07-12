module TopModule (
    input  a,
    input  b,
    input  c,
    output w,
    output x,
    output y,
    output z
);
    // Direct continuous assignments using concatenation for outputs driven by b
    assign w = a;
    assign {x, y} = {b, b};
    assign z = c;
endmodule