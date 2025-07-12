module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    assign out = (~c & ~d & ~b)   // cd=00 & b=0
               | (~c &  d & ~a)   // cd=01 & a=0
               | ( c & ~d & ~a)   // cd=10 & a=0
               | ( c &  d &  b);  // cd=11 & b=1

endmodule