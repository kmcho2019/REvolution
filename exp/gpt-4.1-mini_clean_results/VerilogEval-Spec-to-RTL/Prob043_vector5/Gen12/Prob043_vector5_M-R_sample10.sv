module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

    // Pack inputs into a vector for easy access: inputs[4]=a, inputs[3]=b, ..., inputs[0]=e
    wire [4:0] inputs = {a, b, c, d, e};

    // Explicitly assign each bit of the 25-bit output as XNOR of the pair (i, j)
    // Indexing: out[24 - (5*i + j)] corresponds to inputs[i], inputs[j]
    // i,j from 0 to 4 with inputs[4]=a,...inputs[0]=e => i=4 is 'a', i=0 is 'e'
    assign out[24] = inputs[4] ~^ inputs[4]; // a == a
    assign out[23] = inputs[4] ~^ inputs[3]; // a == b
    assign out[22] = inputs[4] ~^ inputs[2]; // a == c
    assign out[21] = inputs[4] ~^ inputs[1]; // a == d
    assign out[20] = inputs[4] ~^ inputs[0]; // a == e

    assign out[19] = inputs[3] ~^ inputs[4]; // b == a
    assign out[18] = inputs[3] ~^ inputs[3]; // b == b
    assign out[17] = inputs[3] ~^ inputs[2]; // b == c
    assign out[16] = inputs[3] ~^ inputs[1]; // b == d
    assign out[15] = inputs[3] ~^ inputs[0]; // b == e

    assign out[14] = inputs[2] ~^ inputs[4]; // c == a
    assign out[13] = inputs[2] ~^ inputs[3]; // c == b
    assign out[12] = inputs[2] ~^ inputs[2]; // c == c
    assign out[11] = inputs[2] ~^ inputs[1]; // c == d
    assign out[10] = inputs[2] ~^ inputs[0]; // c == e

    assign out[9]  = inputs[1] ~^ inputs[4]; // d == a
    assign out[8]  = inputs[1] ~^ inputs[3]; // d == b
    assign out[7]  = inputs[1] ~^ inputs[2]; // d == c
    assign out[6]  = inputs[1] ~^ inputs[1]; // d == d
    assign out[5]  = inputs[1] ~^ inputs[0]; // d == e

    assign out[4]  = inputs[0] ~^ inputs[4]; // e == a
    assign out[3]  = inputs[0] ~^ inputs[3]; // e == b
    assign out[2]  = inputs[0] ~^ inputs[2]; // e == c
    assign out[1]  = inputs[0] ~^ inputs[1]; // e == d
    assign out[0]  = inputs[0] ~^ inputs[0]; // e == e

endmodule