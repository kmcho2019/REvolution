module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

// Direct implementation based on observed minterms where 'out' is 1
assign out = (a == 0 && b == 0 && c == 0 && d == 0) ||  // a'b'c'd'
             (a == 0 && b == 0 && c == 0 && d == 1) ||  // a'b'cd'
             (a == 0 && b == 1 && c == 0 && d == 0) ||  // a'bc'd'
             (a == 0 && b == 0 && c == 1 && d == 0) ||  // a'b'cd
             (a == 1 && b == 0 && c == 1 && d == 0) ||  // abc'd
             (a == 1 && b == 1 && c == 0 && d == 1) ||  // abcd
             (a == 1 && b == 1 && c == 1 && d == 0) ||  // abcd'
             (a == 1 && b == 1 && c == 1 && d == 1);    // abcd

endmodule