module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

// Intermediate signals for each condition
wire cond1 = a & b & (!c | !d);   // ab=11 cases
wire cond2 = !a & !b & c & d;     // cd=11, ab=00
wire cond3 = !a & b & !c & d;     // cd=01, ab=01
wire cond4 = a & !b & c & !d;     // cd=10, ab=10

// Combine conditions and invert
assign out = !(cond1 | cond2 | cond3 | cond4);

endmodule