module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

// Simplified Boolean expression
assign out = !(
    (c & d & !a & !b) |  // cd=11, ab=00
    (b & d) |            // covers cd=01/11, ab=01/11 when d=1
    (a & b & (!c | !d)) | // ab=11 with either c or d=0
    (a & !b & c & !d)    // cd=10, ab=10
);

endmodule