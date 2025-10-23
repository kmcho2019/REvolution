// Simplified solution directly translating the Karnaugh map conditions.
module TopModule(
    input a,
    input b,
    input c,
    output out
);

// Directly implement the simplified OR logic.
assign out = a | b | c;

endmodule