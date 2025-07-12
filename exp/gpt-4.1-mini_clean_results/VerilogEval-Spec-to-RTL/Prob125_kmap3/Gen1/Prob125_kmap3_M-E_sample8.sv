module TopModule(
    input a,
    input b,
    input c,
    input d, // don't care, can be ignored
    output out
);

// Karnaugh map analysis (variables c,d for rows, a,b for columns):
// Output = 1 for these minterms (cd ab):
// 00 10 -> c=0,d=0,a=1,b=0
// 00 11 -> c=0,d=0,a=1,b=1
// 11 00 -> c=1,d=1,a=0,b=0
// 11 10 -> c=1,d=1,a=1,b=0
// 11 11 -> c=1,d=1,a=1,b=1
// 10 00 -> c=1,d=0,a=0,b=0
// 10 10 -> c=1,d=0,a=1,b=0
// 10 11 -> c=1,d=0,a=1,b=1

// Observing 1s for c=0,d=0: a=1 (b=0 or 1)
// For c=1,d=x: output=1 for all when b=0 or a=1 (a and b cover the row).
// Because d is don't-care, let's treat d as irrelevant and focus on c,a,b.

// We'll implement minterm-like product terms explicitly.

// Product terms:
// T1: ~c & a          (row c=0, a=1: covers (00 10) and (00 11))
// T2: c & ~b          (rows c=1, b=0, all a, covers 11 00, 11 10, 10 00, 10 10)
// T3: c & a           (rows c=1, a=1, covers 11 10, 11 11, 10 10, 10 11)

wire not_c = ~c;
wire not_b = ~b;

wire T1 = not_c & a;
wire T2 = c & not_b;
wire T3 = c & a;

assign out = T1 | T2 | T3;

endmodule