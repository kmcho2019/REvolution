module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

    assign out = (~d & ~b) |
                 (~c & ~d & a & ~b) |
                 (~c & d & ~a & ~b) |
                 (~c & d & a & ~b) |
                 (c & d & ~a & b) |
                 (c & d & a & ~b) |
                 (c & d & a & b) |
                 (c & ~d & ~a & b);

endmodule