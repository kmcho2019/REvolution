module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

// Exception cases where output should be 0 (from K-map)
wire exception1 = (~a & b & c & ~d);  // ab=01, cd=10
wire exception2 = (a & b & ~c & ~d);  // ab=11, cd=00
wire exception3 = (~a & ~b & c & d);  // ab=00, cd=11
wire exception4 = (a & ~b & c & d);   // ab=10, cd=11

// Combine all exceptions
wire any_exception = exception1 | exception2 | exception3 | exception4;

// Output is 1 by default, unless an exception occurs
assign out = ~any_exception;

endmodule