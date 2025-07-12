module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

// Generate all pairwise comparisons
always @(a, b, c, d, e) begin
    // Initialize output
    out = 25'b0;
    
    // Compare each signal with all others including itself
    out[24] = ~(a ^ a); // a with a
    out[23] = ~(a ^ b); // a with b
    out[22] = ~(a ^ c); // a with c
    out[21] = ~(a ^ d); // a with d
    out[20] = ~(a ^ e); // a with e
    out[19] = ~(b ^ a); // b with a
    out[18] = ~(b ^ b); // b with b
    out[17] = ~(b ^ c); // b with c
    out[16] = ~(b ^ d); // b with d
    out[15] = ~(b ^ e); // b with e
    out[14] = ~(c ^ a); // c with a
    out[13] = ~(c ^ b); // c with b
    out[12] = ~(c ^ c); // c with c
    out[11] = ~(c ^ d); // c with d
    out[10] = ~(c ^ e); // c with e
    out[9]  = ~(d ^ a); // d with a
    out[8]  = ~(d ^ b); // d with b
    out[7]  = ~(d ^ c); // d with c
    out[6]  = ~(d ^ d); // d with d
    out[5]  = ~(d ^ e); // d with e
    out[4]  = ~(e ^ a); // e with a
    out[3]  = ~(e ^ b); // e with b
    out[2]  = ~(e ^ c); // e with c
    out[1]  = ~(e ^ d); // e with d
    out[0]  = ~(e ^ e); // e with e
end

endmodule