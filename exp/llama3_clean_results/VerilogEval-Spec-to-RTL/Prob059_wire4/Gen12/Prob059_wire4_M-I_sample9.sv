module TopModule(
    input  a,
    input  b,
    input  c,
    output w,
    output x,
    output y,
    output z
);

// The current implementation is already optimal in terms of simplicity and directness.
// However, to explore potential improvements in area due to synthesis variations,
// we maintain the direct assignment approach, which is both straightforward and efficient.
assign w = a;
assign x = b;
assign y = b;
assign z = c;

endmodule