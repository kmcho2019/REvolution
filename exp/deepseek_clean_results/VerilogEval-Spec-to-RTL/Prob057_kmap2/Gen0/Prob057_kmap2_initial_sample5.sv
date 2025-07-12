module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

    assign out = (~c & ~d) |                 // First two rows when cd=00
                 (c & d & (a ^ b)) |         // Third row when cd=11
                 (~c & d & ~a & b) |         // Second row when cd=01 and ab=01
                 (c & ~d & a & ~b);          // Fourth row when cd=10 and ab=10

endmodule