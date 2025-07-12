// Superior solution combining the strengths of both examples.
module TopModule(
    input a,
    input b,
    input c,
    output out
);

// Directly implement the simplified OR logic for simplicity and efficiency.
assign out = a | b | c;

endmodule