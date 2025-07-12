module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

assign out = (~c & ~d) |             // Covers cd=00 cases
             (c & d & (a | b)) |     // Covers cd=11 cases
             (c & ~d & ~a) |         // Covers cd=10, ab=00,01
             (b & ~a & d);           // Covers remaining 1s

endmodule