module TopModule(
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [3:0] e,
    output [3:0] q
);

    // Concatenate inputs plus constant 4'hF to form a 20-bit vector.
    // Ordering: index 0=b, 1=e, 2=a, 3=d, 4=4'hF.
    wire [19:0] data = {4'hF, d, a, e, b};

    // Clamp c to maximum 4 to avoid out-of-range shifting
    wire [2:0] idx = (c < 4'd5) ? c[2:0] : 3'd4;

    // Use explicit shift left by 2 bits (multiply idx by 4) for efficient synthesis
    assign q = (data >> (idx << 2)) & 4'hF;

endmodule