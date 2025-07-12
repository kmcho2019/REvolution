module TopModule(
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [3:0] e,
    output [3:0] q
);

    // Concatenate inputs and 4'hF as a 20-bit vector
    wire [19:0] data = {4'hF, d, a, e, b};

    // Clamp c to maximum 4 to avoid out-of-bound shift
    wire [2:0] idx = (c < 5) ? c[2:0] : 3'd4;

    // Extract 4 bits by shifting right by multiples of 4 (using shift by (idx << 2))
    assign q = (data >> (idx << 2)) & 4'hF;

endmodule