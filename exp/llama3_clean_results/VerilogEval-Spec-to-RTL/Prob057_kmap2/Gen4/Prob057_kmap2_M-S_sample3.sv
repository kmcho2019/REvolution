module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);

assign out = (~a & ~b & c & ~d) | 
             (~a & b & c & d) | 
             (b & c & d) | 
             (a & ~b & ~c & ~d) | 
             (a & ~b & ~c & d) | 
             (a & b & ~c & d) | 
             (a & b & c & d);

// Simplified version based on Karnaugh map analysis:
// Notice the common factor (c & d) in several terms, and other patterns
assign out = (a & ~b & ~c & (~d | d)) | 
             (~a & ~b & c & ~d) | 
             (b & c & d) | 
             (a & b & (~c | c) & d);

// Further simplification by applying Boolean algebra rules:
assign out = (a & ~b & ~c) | 
             (~a & ~b & c & ~d) | 
             (b & c & d) | 
             (a & b & d);

// Final simplified form:
assign out = (a & ~b & ~c) | 
             (a & b & d) | 
             (b & c & d) | 
             (~a & ~b & c & ~d);

endmodule