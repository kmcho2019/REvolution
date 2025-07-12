module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

assign out = (~c & ~d) ? ~(a & b) :       // cd=00 case: output 1 unless ab=11
             (c & d) ? (a | b) :           // cd=11 case: output 1 unless ab=00
             (c & ~d) ? (~a | ~b) :       // cd=10 case: output 1 when ab=00 or 01
             (~a | (b & d));               // cd=01 case: complex pattern

endmodule