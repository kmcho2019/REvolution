module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,  // don't-care, unused
    output out
);

// Implement the logic as a mux on 'a'.
// When a=1 -> out = 1 (true)
// When a=0 -> out = c & ~b

wire func_zero = c & ~b;

assign out = a ? 1'b1 : func_zero;

endmodule