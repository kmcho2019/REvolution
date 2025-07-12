// Superior solution combining the strengths of both examples
module TopModule(
    input a,
    input b,
    input c,
    output out
);

// Maintain the efficient and straightforward OR gate logic
// This implementation is optimal for area and performance
assign out = a | b | c;

endmodule