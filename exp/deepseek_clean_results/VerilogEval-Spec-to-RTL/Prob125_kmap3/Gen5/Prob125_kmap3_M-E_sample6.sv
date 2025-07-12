module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);
    // Priority-based output selection
    assign out = (~c & d) ? 1'b0 :        // cd=01 always 0
                 (~a & b) ? (c | d) :     // ab=01: 0 only when cd=00
                 (~a & ~b & ~c & ~d) ? 1'b0 :  // ab=00,cd=00
                 1'b1;                    // default case
endmodule