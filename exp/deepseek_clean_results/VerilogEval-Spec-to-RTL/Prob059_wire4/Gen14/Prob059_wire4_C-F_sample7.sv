module TopModule (
    input  a,
    input  b,
    input  c,
    output w,
    output x,
    output y,
    output z
);
    // Direct wire connections grouped by input source
    assign w = a;    // a drives w
    assign x = b;    // b drives x
    assign y = b;    // b also drives y
    assign z = c;    // c drives z
endmodule