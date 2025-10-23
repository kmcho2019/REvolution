module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

// Define all product terms explicitly for clarity
wire term1 = ~c & ~d & a & b;  // cd=00, ab=11
wire term2 = ~c &  d &      b;  // cd=01, b=1
wire term3 =  c & ~d & a     ;  // cd=10, a=1
wire term4 =  c &  d & ~a & ~b; // cd=11, ab=00

// Single-level NOR implementation for optimal timing
assign out = ~(term1 | term2 | term3 | term4);

endmodule