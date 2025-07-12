module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    assign out = 
        (~c & ~d & ~(a & b))       // cd=00 and not (a & b)
      | ( c &  d & (a | b))        // cd=11 and (a or b)
      | ( c & ~d & ~a)             // cd=10 and a=0
      | (~c &  d & ~b);            // cd=01 and b=0

endmodule