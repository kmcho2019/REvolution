module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

// Majority function of 3 inputs
wire maj_abc = (a & b) | (a & c) | (b & c);
wire maj_abd = (a & b) | (a & d) | (b & d);
wire maj_bcd = (b & c) | (b & d) | (c & d);

// Correction terms for specific patterns
wire correction1 = ~a & ~b & c & d;  // cd=11, ab=00
wire correction2 = a & b & ~c & ~d;  // cd=00, ab=11
wire correction3 = ~c & d & b;       // cd=01 cases
wire correction4 = c & ~d & a;       // cd=10 cases

// Combined correction signal
wire correction = correction1 | correction2 | correction3 | correction4;

// Final output with selective inversion
assign out = maj_abc ^ correction;

endmodule