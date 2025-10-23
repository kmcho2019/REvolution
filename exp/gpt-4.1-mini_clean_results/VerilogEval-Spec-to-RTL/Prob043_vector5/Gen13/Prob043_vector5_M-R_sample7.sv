module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    input  e,
    output [24:0] out
);

    wire [4:0] inputs = {a, b, c, d, e};

    // Intermediate 2D array holding each comparison
    wire comp [4:0][4:0];

    // Generate intermediate comparisons without generate block
    assign comp[0][0] = ~(inputs[4] ^ inputs[4]);
    assign comp[0][1] = ~(inputs[4] ^ inputs[3]);
    assign comp[0][2] = ~(inputs[4] ^ inputs[2]);
    assign comp[0][3] = ~(inputs[4] ^ inputs[1]);
    assign comp[0][4] = ~(inputs[4] ^ inputs[0]);

    assign comp[1][0] = ~(inputs[3] ^ inputs[4]);
    assign comp[1][1] = ~(inputs[3] ^ inputs[3]);
    assign comp[1][2] = ~(inputs[3] ^ inputs[2]);
    assign comp[1][3] = ~(inputs[3] ^ inputs[1]);
    assign comp[1][4] = ~(inputs[3] ^ inputs[0]);

    assign comp[2][0] = ~(inputs[2] ^ inputs[4]);
    assign comp[2][1] = ~(inputs[2] ^ inputs[3]);
    assign comp[2][2] = ~(inputs[2] ^ inputs[2]);
    assign comp[2][3] = ~(inputs[2] ^ inputs[1]);
    assign comp[2][4] = ~(inputs[2] ^ inputs[0]);

    assign comp[3][0] = ~(inputs[1] ^ inputs[4]);
    assign comp[3][1] = ~(inputs[1] ^ inputs[3]);
    assign comp[3][2] = ~(inputs[1] ^ inputs[2]);
    assign comp[3][3] = ~(inputs[1] ^ inputs[1]);
    assign comp[3][4] = ~(inputs[1] ^ inputs[0]);

    assign comp[4][0] = ~(inputs[0] ^ inputs[4]);
    assign comp[4][1] = ~(inputs[0] ^ inputs[3]);
    assign comp[4][2] = ~(inputs[0] ^ inputs[2]);
    assign comp[4][3] = ~(inputs[0] ^ inputs[1]);
    assign comp[4][4] = ~(inputs[0] ^ inputs[0]);

    // Flatten comp into out using a single assign
    assign out = {
        comp[0][0], comp[0][1], comp[0][2], comp[0][3], comp[0][4],
        comp[1][0], comp[1][1], comp[1][2], comp[1][3], comp[1][4],
        comp[2][0], comp[2][1], comp[2][2], comp[2][3], comp[2][4],
        comp[3][0], comp[3][1], comp[3][2], comp[3][3], comp[3][4],
        comp[4][0], comp[4][1], comp[4][2], comp[4][3], comp[4][4]
    };

endmodule