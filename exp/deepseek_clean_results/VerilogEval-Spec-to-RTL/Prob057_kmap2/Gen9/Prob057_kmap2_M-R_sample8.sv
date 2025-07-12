module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

// Alternative Boolean expression derived from K-map
// out is 1 when any of these conditions are true:
assign out = (!c & !d) |           // cd=00
             (!a & !d) |           // a=0, d=0
             (a & b & d) |         // a=1, b=1, d=1
             (!a & b & !c) |       // a=0, b=1, c=0
             (a & !b & c);         // a=1, b=0, c=1

endmodule