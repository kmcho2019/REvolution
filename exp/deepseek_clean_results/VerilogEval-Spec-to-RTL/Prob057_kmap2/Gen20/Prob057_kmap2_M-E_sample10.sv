module TopModule (
    input a,
    input b,
    input c,
    input d,
    output out
);

// Implement as 4:1 mux with a,b as selectors
assign out = (~a & ~b) ? (~d | ~c) :  // ab=00
             (~a &  b) ? (~c | d)  :  // ab=01
             ( a &  b) ? (c | ~d)  :  // ab=11
                         (c & d);     // ab=10

endmodule