module TopModule (
    input  in1,
    input  in2,
    output out
);

// Implement AND gate with a bubble (inversion) on the in2 input:
// The 'bubble' indicates that in2 is inverted before the AND operation.
// Output is high only when in1 is high and in2 is low.
assign out = in1 & ~in2;

endmodule