module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,    // d is don't-care, ignored
    output out
);

// Derive output expression from Karnaugh map and don't-cares:
// For each ab column:
// 00 (a=0,b=0): out = c
// 01 (a=0,b=1): out = 0 (assign d=0)
// 10 (a=1,b=0): out = 1 (assign d=1)
// 11 (a=1,b=1): out = 1 (assign d=1)

// Express output as:
// out = (~a & ~b & c) | (a & b) | (a & ~b)

// Simplify:
// (a & b) | (a & ~b) = a
// So final expression:
// out = (~a & ~b & c) | a

assign out = ( (~a) & (~b) & c ) | a;

endmodule