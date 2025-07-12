module TopModule(
    input a,
    input b,
    input c,
    input d,
    output out
);
    // Priority-based implementation
    wire cd01 = ~c & d;
    wire cd00 = ~c & ~d;
    wire cd1x = c;
    wire ab_not_10_11 = ~(a & ~b) & ~(a & b);  // ab is 00 or 01
    
    assign out = ~(cd01 |                    // Force 0 when cd=01
                 (cd00 & ab_not_10_11) |     // Force 0 when cd=00 and ab is 00/01
                 (cd1x & ~a & b));           // Force 0 when cd=1x and ab=01
endmodule