module TopModule (
    input [4:0] a,
    input [4:0] b,
    input [4:0] c,
    input [4:0] d,
    input [4:0] e,
    input [4:0] f,
    output [7:0] w,
    output [7:0] x,
    output [7:0] y,
    output [7:0] z
);

    // Concatenate all inputs (6x5b = 30b) + 2'b11 padding = 32b total
    // Output mapping:
    // w[7:0] = {a, b[4:3]}       (bits 31-24)
    // x[7:0] = {b[2:0], c, d[4]} (bits 23-16)
    // y[7:0] = {d[3:0], e}       (bits 15-8)
    // z[7:0] = {f, 2'b11}        (bits 7-0)
    assign {w, x, y, z} = {a, b, c, d, e, f, 2'b11};

endmodule