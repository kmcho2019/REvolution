module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

// Simplified Boolean expression derived from K-map
assign out = (!c & !d) |         // cd=00
             (!a & !d) |         // a=0, d=0
             (a & b & c) |       // a=1, b=1, c=1
             (!b & c & !d) |     // b=0, c=1, d=0
             (a & !b & !c);      // a=1, b=0, c=0

endmodule