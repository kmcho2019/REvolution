module TopModule(
    input a,
    input b,
    input c,
    input d,
    output q
);

// Directly assign q based on the conditions of a, b, and c using a single assign statement
assign q = (b || c) || (a && (b || c));

endmodule