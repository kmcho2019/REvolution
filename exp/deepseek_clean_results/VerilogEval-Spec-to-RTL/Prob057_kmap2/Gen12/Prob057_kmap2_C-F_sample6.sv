module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

// Optimized fusion of both examples:
// - Clear mapping to K-map 0s (like Example 1)
// - Efficient term merging (like Example 2)
assign out = ~(
    (!a & !b & c & d) |  // cd=11, ab=00
    (a & b & (!c | !d)) | // Merges cd=01/10/00 when ab=11
    (!c & d & b) |       // cd=01, ab=01/11
    (c & !d & a)         // cd=10, ab=11/10
);

endmodule