module TopModule (
    input  [4:0] a,
    input  [4:0] b,
    input  [4:0] c,
    input  [4:0] d,
    input  [4:0] e,
    input  [4:0] f,
    output [7:0] w,
    output [7:0] x,
    output [7:0] y,
    output [7:0] z
);

    // Define a named constant for the appended two '1' bits
    localparam [1:0] TWO_ONES = 2'b11;

    // Concatenate all inputs and the constant bits explicitly into a 32-bit wire
    wire [31:0] concatenated = {a, b, c, d, e, f, TWO_ONES};

    // Assign all 8-bit outputs simultaneously from the concatenated wire
    assign {w, x, y, z} = concatenated;

endmodule