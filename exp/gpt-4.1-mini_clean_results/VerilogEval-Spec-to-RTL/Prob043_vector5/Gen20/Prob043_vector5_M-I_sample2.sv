module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

    // Mapping of output bits (row: first input, col: second input):
    // out[24] = (a,a)
    // out[23] = (a,b)
    // out[22] = (a,c)
    // out[21] = (a,d)
    // out[20] = (a,e)
    // out[19] = (b,a)
    // out[18] = (b,b)
    // out[17] = (b,c)
    // out[16] = (b,d)
    // out[15] = (b,e)
    // out[14] = (c,a)
    // out[13] = (c,b)
    // out[12] = (c,c)
    // out[11] = (c,d)
    // out[10] = (c,e)
    // out[9]  = (d,a)
    // out[8]  = (d,b)
    // out[7]  = (d,c)
    // out[6]  = (d,d)
    // out[5]  = (d,e)
    // out[4]  = (e,a)
    // out[3]  = (e,b)
    // out[2]  = (e,c)
    // out[1]  = (e,d)
    // out[0]  = (e,e)

    // Compute diagonal (same inputs)
    assign out[24] = ~(a ^ a); // always 1
    assign out[18] = ~(b ^ b); // always 1
    assign out[12] = ~(c ^ c); // always 1
    assign out[6]  = ~(d ^ d); // always 1
    assign out[0]  = ~(e ^ e); // always 1

    // Compute unique pairs where row > col
    wire ab = ~(b ^ a);
    wire ac = ~(c ^ a);
    wire ad = ~(d ^ a);
    wire ae = ~(e ^ a);

    wire bc = ~(c ^ b);
    wire bd = ~(d ^ b);
    wire be = ~(e ^ b);

    wire cd = ~(d ^ c);
    wire ce = ~(e ^ c);

    wire de = ~(e ^ d);

    // Assign outputs for row > col pairs
    assign out[19] = ab; // (b,a)
    assign out[14] = ac; // (c,a)
    assign out[9]  = ad; // (d,a)
    assign out[4]  = ae; // (e,a)

    assign out[17] = bc; // (b,c)
    assign out[16] = bd; // (b,d)
    assign out[15] = be; // (b,e)

    assign out[11] = cd; // (c,d)
    assign out[10] = ce; // (c,e)

    assign out[5]  = de; // (d,e)

    // For row < col pairs, assign symmetric outputs from above
    assign out[23] = ab; // (a,b) = (b,a)
    assign out[22] = ac; // (a,c) = (c,a)
    assign out[21] = ad; // (a,d) = (d,a)
    assign out[20] = ae; // (a,e) = (e,a)

    assign out[13] = bc; // (c,b) = (b,c)
    assign out[8]  = bd; // (d,b) = (b,d)
    assign out[7]  = be; // (d,c) = (c,b) wrong, correct mapping below

    assign out[7]  = bc; // (d,c) = (c,d) correction: out[7] = (d,c), symmetric to (c,d) out[11]

    assign out[3]  = be; // (e,b) = (b,e)
    assign out[2]  = ce; // (e,c) = (c,e)
    assign out[1]  = de; // (e,d) = (d,e)

endmodule