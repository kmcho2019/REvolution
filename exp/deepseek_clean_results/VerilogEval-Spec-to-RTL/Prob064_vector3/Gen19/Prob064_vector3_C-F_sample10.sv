module TopModule (
    input [4:0] a, b, c, d, e, f,
    output [7:0] w, x, y, z
);

    // Direct concatenation and splitting with precise bit control
    assign {w, x, y, z} = {a, b, c, d, e, f, 2'b11};

endmodule