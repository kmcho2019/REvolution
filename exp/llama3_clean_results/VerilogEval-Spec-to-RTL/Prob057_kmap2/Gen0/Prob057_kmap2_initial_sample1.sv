module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);

// The Karnaugh map can be translated into the following logic expression:
// out = (!c & !d & (a | b)) | (!c & d & (a | !b)) | (c & !d & !a & !b) | (c & d & (a | b));

// Simplifying the expression based on the observed patterns in the Karnaugh map
assign out = (!c & !d & (a | b)) | (!c & d & (a | !b)) | (c & d & (a | b)) | (!a & !c & d & b);

endmodule