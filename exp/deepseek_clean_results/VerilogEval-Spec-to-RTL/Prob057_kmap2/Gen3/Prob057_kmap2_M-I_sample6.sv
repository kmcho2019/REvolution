module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

    assign out = (~c & ((~d & (~a | ~b | (a & ~b))) | (d & (~a | ~b)))) |
                 (c & ((d & b) | (~d & (~a | b))));

endmodule