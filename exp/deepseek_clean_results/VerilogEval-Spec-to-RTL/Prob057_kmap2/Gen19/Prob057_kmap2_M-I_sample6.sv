module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

// Detect the four cases where output should be 0
wire case1 = c & d & ~a & ~b;   // cd=11, ab=00
wire case2 = ~c & d & ~a & b;    // cd=01, ab=01
wire case3 = ~c & d & a & b;     // cd=01, ab=11
wire case4 = c & ~d & a & b;     // cd=10, ab=11

// Output is 1 unless one of the 0-cases is true
assign out = ~(case1 | case2 | case3 | case4);

endmodule