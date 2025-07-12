module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

    assign out = (~c & (~a | (~d & ~b) | (d & b))) |
                 (c & (a | (d & b) | (~d & ~b)));

endmodule