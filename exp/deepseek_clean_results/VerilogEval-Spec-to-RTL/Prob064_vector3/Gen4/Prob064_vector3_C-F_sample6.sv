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

    // Concatenate all six 5-bit inputs and pad with two '1's in LSBs
    // Then split directly into four 8-bit outputs
    assign {w, x, y, z} = {a, b, c, d, e, f, 2'b11};

endmodule