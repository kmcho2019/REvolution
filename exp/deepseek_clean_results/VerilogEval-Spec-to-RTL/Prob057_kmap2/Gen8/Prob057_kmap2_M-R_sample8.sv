module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

assign out = (~c & ~d & (~(a & b))) |  // Top two rows except ab=11
             (~d & a & ~b) |           // Left middle when c=0
             (c & d & (a | b)) |       // Bottom right quadrant
             (d & ~c & b);             // Top right when cd=01

endmodule