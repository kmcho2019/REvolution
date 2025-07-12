module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,    // d is don't-care, ignored in logic
    output out
);

// Minimal expression derived from Karnaugh map with don't-cares:
// out = a + c * (~b)
// This covers all required minterms and uses minimal gates.

assign out = a | (c & ~b);

endmodule