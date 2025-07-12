module TopModule (
    input x3,
    input x2,
    input x1,
    output f
);

// Simplified expression: f = (x2 and !x3) or (x1 and x3) or (x2 and x1)
// However, noticing that (x2 and x1) is included in both (x2 and !x3) and (x1 and x3) when x2=1 or x1=1,
// we can simplify this further by considering the cases when x2 or x1 are 1 separately.
assign f = (x2 && !x3) || (x1 && x3) || (x2 && x1);

// Further simplification based on Karnaugh map or logical reduction techniques may be possible,
// but given the small size of the truth table and the simplicity of the current expression,
// significant area or power reductions might not be achievable without more complex optimizations.

endmodule