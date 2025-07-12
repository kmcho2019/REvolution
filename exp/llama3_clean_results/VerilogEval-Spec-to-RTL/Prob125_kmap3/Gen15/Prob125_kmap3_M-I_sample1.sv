module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

// The current implementation is straightforward and efficient.
// To potentially reduce area or power, we could explore alternative
// logical expressions, but significant improvements are unlikely
// without changing the basic logic.

assign out = a | (~a & ~b & c);

endmodule