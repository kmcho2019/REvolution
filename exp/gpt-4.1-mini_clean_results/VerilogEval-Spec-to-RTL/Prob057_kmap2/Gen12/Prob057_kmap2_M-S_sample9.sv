module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);
    assign out = 
        (~d & ~a) |
        (~c & ~b) |
        (c & d & (a | b)) |
        (d & ~c & ~a & b);
endmodule