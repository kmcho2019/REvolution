module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);
    wire bit0_neq;
    wire bit1_neq;
    wire any_neq;

    // Compare lower bits: a vs c
    assign bit0_neq = a ^ c;

    // Compare higher bits: b vs d
    assign bit1_neq = b ^ d;

    // Check if any bits differ
    assign any_neq = bit0_neq | bit1_neq;

    // Output is 1 if {a,b} != {c,d}, else 0
    assign out = any_neq;

endmodule