module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

assign out = !(
    (~c & ~d & a & b) |  // case 1
    (~c & d & b) |       // case 2
    (c & ~d & a) |       // case 3
    (c & d & ~a & ~b)    // case 4
);

endmodule