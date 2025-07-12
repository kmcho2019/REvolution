module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

// Invert inputs where needed inline in expressions
assign out = 
      (~c & ~d & (~a | ~b))   // minterm group: nc & nd & (na | nb)
    | (~c &  d & ~b)         // nc & d & nb
    | ( c & ~d & ~a)         // c & nd & na
    | ( c &  d & (a | b));   // c & d & (a | b)

endmodule