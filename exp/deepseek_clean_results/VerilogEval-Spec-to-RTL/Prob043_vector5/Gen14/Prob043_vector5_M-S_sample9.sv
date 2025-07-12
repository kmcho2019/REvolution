module TopModule (
    input a,
    input b,
    input c,
    input d,
    input e,
    output [24:0] out
);

    // Output ordering:
    // a-a, a-b, a-c, a-d, a-e,
    // b-a, b-b, b-c, b-d, b-e,
    // c-a, c-b, c-c, c-d, c-e,
    // d-a, d-b, d-c, d-d, d-e,
    // e-a, e-b, e-c, e-d, e-e

    // Row 1 (a vs all)
    assign out[24] = 1'b1;                // a-a
    assign out[23] = ~(a ^ b);            // a-b
    assign out[22] = ~(a ^ c);            // a-c
    assign out[21] = ~(a ^ d);            // a-d
    assign out[20] = ~(a ^ e);            // a-e

    // Row 2 (b vs all)
    assign out[19] = ~(b ^ a);            // b-a
    assign out[18] = 1'b1;                // b-b
    assign out[17] = ~(b ^ c);            // b-c
    assign out[16] = ~(b ^ d);            // b-d
    assign out[15] = ~(b ^ e);            // b-e

    // Row 3 (c vs all)
    assign out[14] = ~(c ^ a);            // c-a
    assign out[13] = ~(c ^ b);            // c-b
    assign out[12] = 1'b1;                // c-c
    assign out[11] = ~(c ^ d);            // c-d
    assign out[10] = ~(c ^ e);            // c-e

    // Row 4 (d vs all)
    assign out[9]  = ~(d ^ a);            // d-a
    assign out[8]  = ~(d ^ b);            // d-b
    assign out[7]  = ~(d ^ c);            // d-c
    assign out[6]  = 1'b1;                // d-d
    assign out[5]  = ~(d ^ e);            // d-e

    // Row 5 (e vs all)
    assign out[4]  = ~(e ^ a);            // e-a
    assign out[3]  = ~(e ^ b);            // e-b
    assign out[2]  = ~(e ^ c);            // e-c
    assign out[1]  = ~(e ^ d);            // e-d
    assign out[0]  = 1'b1;                // e-e

endmodule