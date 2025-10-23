module TopModule (
    input [4:0] a, b, c, d, e, f,
    output [7:0] w, x, y, z
);

    // First output gets bits [31:24] of the concatenated result
    assign w = {a, b[4:2]};
    // Second output gets bits [23:16]
    assign x = {b[1:0], c, d[4:4]};
    // Third output gets bits [15:8]
    assign y = {d[3:0], e[4:1]};
    // Fourth output gets bits [7:0] (with 2'b11 LSBs)
    assign z = {e[0], f, 2'b11};

endmodule