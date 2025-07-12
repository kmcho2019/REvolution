module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);
    wire [4:0] inputs = {a, b, c, d, e};

    // Create 5 rows of XNOR comparisons:
    wire [4:0] row0 = ~(inputs[4] ^ inputs); // comparisons of a (inputs[4]) with all inputs
    wire [4:0] row1 = ~(inputs[3] ^ inputs); // b
    wire [4:0] row2 = ~(inputs[2] ^ inputs); // c
    wire [4:0] row3 = ~(inputs[1] ^ inputs); // d
    wire [4:0] row4 = ~(inputs[0] ^ inputs); // e

    // Concatenate rows in order from a to e to form 25 bits
    // Note: out[24] = row0[4] = ~(a ^ a)
    //       out[23] = row0[3] = ~(a ^ b), etc.
    assign out = {row0, row1, row2, row3, row4};

endmodule