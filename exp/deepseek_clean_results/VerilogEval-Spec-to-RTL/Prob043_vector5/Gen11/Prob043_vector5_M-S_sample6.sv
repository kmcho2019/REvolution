module TopModule (
    input a,
    input b,
    input c,
    input d,
    input e,
    output [24:0] out
);
    // Output bit assignments in the specified order:
    // Group 1: a comparisons (bits 24-20)
    assign out[24] = ~a ^ a;  // a == a
    assign out[23] = ~a ^ b;  // a == b
    assign out[22] = ~a ^ c;  // a == c
    assign out[21] = ~a ^ d;  // a == d
    assign out[20] = ~a ^ e;  // a == e
    
    // Group 2: b comparisons (bits 19-15)
    assign out[19] = ~b ^ a;  // b == a
    assign out[18] = ~b ^ b;  // b == b
    assign out[17] = ~b ^ c;  // b == c
    assign out[16] = ~b ^ d;  // b == d
    assign out[15] = ~b ^ e;  // b == e
    
    // Group 3: c comparisons (bits 14-10)
    assign out[14] = ~c ^ a;  // c == a
    assign out[13] = ~c ^ b;  // c == b
    assign out[12] = ~c ^ c;  // c == c
    assign out[11] = ~c ^ d;  // c == d
    assign out[10] = ~c ^ e;  // c == e
    
    // Group 4: d comparisons (bits 9-5)
    assign out[9] = ~d ^ a;   // d == a
    assign out[8] = ~d ^ b;   // d == b
    assign out[7] = ~d ^ c;   // d == c
    assign out[6] = ~d ^ d;   // d == d
    assign out[5] = ~d ^ e;   // d == e
    
    // Group 5: e comparisons (bits 4-0)
    assign out[4] = ~e ^ a;   // e == a
    assign out[3] = ~e ^ b;   // e == b
    assign out[2] = ~e ^ c;   // e == c
    assign out[1] = ~e ^ d;   // e == d
    assign out[0] = ~e ^ e;   // e == e
endmodule