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

    // Directly assign output slices from concatenated inputs and appended two '1's at LSB
    assign w = {a, b}[15:8];  // partial slice, so better to assign full concatenation in one go
    // Instead, directly assign all outputs from concatenation expression without intermediate wire
    assign {w, x, y, z} = {a, b, c, d, e, f, 2'b11};

endmodule