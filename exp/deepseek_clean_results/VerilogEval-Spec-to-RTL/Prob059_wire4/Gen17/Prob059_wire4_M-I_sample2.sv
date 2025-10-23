module TopModule (
    input  a,
    input  b,
    input  c,
    output w,
    output x, y,
    output z
);
    assign w = a;
    assign x = b, y = b;
    assign z = c;
endmodule