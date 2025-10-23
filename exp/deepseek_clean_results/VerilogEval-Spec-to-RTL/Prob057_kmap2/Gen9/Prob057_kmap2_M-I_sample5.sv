module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

// Direct implementation of the K-map's 1s using positive logic
assign out = (~c & ~d) |                 // cd=00 covers ab=00,01,10
             (~c & d & ~b) |             // cd=01, ab=00,10
             (c & ~d & ~a) |             // cd=10, ab=00
             (c & ~d & b) |              // cd=10, ab=01
             (c & d & (a | b));          // cd=11 covers ab=01,10,11

endmodule