module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

    // Pack inputs vector: inputs[4] = a, inputs[3] = b, inputs[2] = c, inputs[1] = d, inputs[0] = e
    wire [4:0] inputs = {a, b, c, d, e};

    // Declare wire array to hold upper triangle (i <= j) XNOR comparisons
    wire [4:0] cmp_row0; // cmp[0][j] for j=0..4
    wire [4:0] cmp_row1; // cmp[1][j] for j=1..4 (cmp[1][0] mirrored)
    wire [4:0] cmp_row2; // cmp[2][j] for j=2..4
    wire [4:0] cmp_row3; // cmp[3][j] for j=3..4
    wire [4:0] cmp_row4; // cmp[4][4] only

    // Compute upper triangle including diagonal with XNOR
    // cmp[i][j] = (inputs[4 - i] XNOR inputs[4 - j]) for i <= j

    assign cmp_row0[0] = ~(inputs[4 - 0] ^ inputs[4 - 0]); // (a,a)
    assign cmp_row0[1] = ~(inputs[4 - 0] ^ inputs[4 - 1]); // (a,b)
    assign cmp_row0[2] = ~(inputs[4 - 0] ^ inputs[4 - 2]); // (a,c)
    assign cmp_row0[3] = ~(inputs[4 - 0] ^ inputs[4 - 3]); // (a,d)
    assign cmp_row0[4] = ~(inputs[4 - 0] ^ inputs[4 - 4]); // (a,e)

    assign cmp_row1[1] = ~(inputs[4 - 1] ^ inputs[4 - 1]); // (b,b)
    assign cmp_row1[2] = ~(inputs[4 - 1] ^ inputs[4 - 2]); // (b,c)
    assign cmp_row1[3] = ~(inputs[4 - 1] ^ inputs[4 - 3]); // (b,d)
    assign cmp_row1[4] = ~(inputs[4 - 1] ^ inputs[4 - 4]); // (b,e)

    assign cmp_row2[2] = ~(inputs[4 - 2] ^ inputs[4 - 2]); // (c,c)
    assign cmp_row2[3] = ~(inputs[4 - 2] ^ inputs[4 - 3]); // (c,d)
    assign cmp_row2[4] = ~(inputs[4 - 2] ^ inputs[4 - 4]); // (c,e)

    assign cmp_row3[3] = ~(inputs[4 - 3] ^ inputs[4 - 3]); // (d,d)
    assign cmp_row3[4] = ~(inputs[4 - 3] ^ inputs[4 - 4]); // (d,e)

    assign cmp_row4[4] = ~(inputs[4 - 4] ^ inputs[4 - 4]); // (e,e)

    // Now assign output bits according to problem mapping:
    // out[24] = (a,a) = cmp[0][0] = cmp_row0[0]
    // out[23] = (a,b) = cmp[0][1] = cmp_row0[1]
    // out[22] = (a,c) = cmp[0][2] = cmp_row0[2]
    // out[21] = (a,d) = cmp[0][3] = cmp_row0[3]
    // out[20] = (a,e) = cmp[0][4] = cmp_row0[4]
    //
    // out[19] = (b,a) = cmp[1][0] = mirror cmp[0][1] = cmp_row0[1]
    // out[18] = (b,b) = cmp[1][1] = cmp_row1[1]
    // out[17] = (b,c) = cmp[1][2] = cmp_row1[2]
    // out[16] = (b,d) = cmp[1][3] = cmp_row1[3]
    // out[15] = (b,e) = cmp[1][4] = cmp_row1[4]
    //
    // out[14] = (c,a) = cmp[2][0] = mirror cmp[0][2] = cmp_row0[2]
    // out[13] = (c,b) = cmp[2][1] = mirror cmp[1][2] = cmp_row1[2]
    // out[12] = (c,c) = cmp[2][2] = cmp_row2[2]
    // out[11] = (c,d) = cmp[2][3] = cmp_row2[3]
    // out[10] = (c,e) = cmp[2][4] = cmp_row2[4]
    //
    // out[9] = (d,a) = cmp[3][0] = mirror cmp[0][3] = cmp_row0[3]
    // out[8] = (d,b) = cmp[3][1] = mirror cmp[1][3] = cmp_row1[3]
    // out[7] = (d,c) = cmp[3][2] = mirror cmp[2][3] = cmp_row2[3]
    // out[6] = (d,d) = cmp[3][3] = cmp_row3[3]
    // out[5] = (d,e) = cmp[3][4] = cmp_row3[4]
    //
    // out[4] = (e,a) = cmp[4][0] = mirror cmp[0][4] = cmp_row0[4]
    // out[3] = (e,b) = cmp[4][1] = mirror cmp[1][4] = cmp_row1[4]
    // out[2] = (e,c) = cmp[4][2] = mirror cmp[2][4] = cmp_row2[4]
    // out[1] = (e,d) = cmp[4][3] = mirror cmp[3][4] = cmp_row3[4]
    // out[0] = (e,e) = cmp[4][4] = cmp_row4[4]

    assign out[24] = cmp_row0[0];           // (a,a)
    assign out[23] = cmp_row0[1];           // (a,b)
    assign out[22] = cmp_row0[2];           // (a,c)
    assign out[21] = cmp_row0[3];           // (a,d)
    assign out[20] = cmp_row0[4];           // (a,e)

    assign out[19] = cmp_row0[1];           // (b,a) mirror
    assign out[18] = cmp_row1[1];           // (b,b)
    assign out[17] = cmp_row1[2];           // (b,c)
    assign out[16] = cmp_row1[3];           // (b,d)
    assign out[15] = cmp_row1[4];           // (b,e)

    assign out[14] = cmp_row0[2];           // (c,a) mirror
    assign out[13] = cmp_row1[2];           // (c,b) mirror
    assign out[12] = cmp_row2[2];           // (c,c)
    assign out[11] = cmp_row2[3];           // (c,d)
    assign out[10] = cmp_row2[4];           // (c,e)

    assign out[9]  = cmp_row0[3];           // (d,a) mirror
    assign out[8]  = cmp_row1[3];           // (d,b) mirror
    assign out[7]  = cmp_row2[3];           // (d,c) mirror
    assign out[6]  = cmp_row3[3];           // (d,d)
    assign out[5]  = cmp_row3[4];           // (d,e)

    assign out[4]  = cmp_row0[4];           // (e,a) mirror
    assign out[3]  = cmp_row1[4];           // (e,b) mirror
    assign out[2]  = cmp_row2[4];           // (e,c) mirror
    assign out[1]  = cmp_row3[4];           // (e,d) mirror
    assign out[0]  = cmp_row4[4];           // (e,e)

endmodule