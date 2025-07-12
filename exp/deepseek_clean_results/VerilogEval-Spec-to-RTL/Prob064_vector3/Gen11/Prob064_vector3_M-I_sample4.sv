module TopModule (
    input [4:0] a, b, c, d, e, f,
    output [7:0] w, x, y, z
);

    localparam PAD = 2'b11;
    assign {w, x, y, z} = {a, b, c, d, e, f, PAD};

endmodule