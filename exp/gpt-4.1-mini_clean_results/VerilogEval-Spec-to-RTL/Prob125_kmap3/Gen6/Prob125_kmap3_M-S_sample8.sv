module TopModule(
    input  a,
    input  b,
    input  c,
    input  d, // don't-care input, ignored in logic
    output out
);

// Simplified expression:
// Using don't-care d to choose a simpler function:
// out = a OR c
// This covers all required '1's and assigns '1' to some don't-care states,
// reducing complexity and gate count.

assign out = a | c;

endmodule