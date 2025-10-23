module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);

// Simplified implementation based on re-analysis of the Karnaugh map
assign out = (~c & ~d & ~a) | 
             (b & ~d & ~c) | 
             (d & ~b & ~c) | 
             (~a & b & c) | 
             (a & d);

// However, a more thorough simplification taking into account all interactions and possible reductions in the Karnaugh map results in the following expression:
// Simplified expression considering all '1's and their combinations in the Karnaugh map
assign out = (~a & ~c) | (b & ~d) | (a & d);

endmodule