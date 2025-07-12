module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

assign out = (~c & ~d) |               // cd=00 terms
             (~d & ~b) |               // Common ~d&~b terms
             (c & d & (~a | b)) |      // cd=11 terms
             (c & ~d & ~a & b);        // cd=10, ab=01 term

endmodule