module TopModule(
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [3:0] e,
    output [3:0] q
);

    // Concatenate the inputs in order corresponding to c indices 0..4
    // Index 0: b, 1: e, 2: a, 3: d, 4: 4'hF constant
    wire [19:0] data = {4'hF, d, a, e, b};

    // Clamp c to max index 4 to avoid out-of-range shifting
    wire [2:0] idx = (c > 4) ? 3'd4 : c[2:0];

    // Use explicit shift left by (idx * 4) bits to select correct nibble
    // Shifting right is allowed but shifting left is equally valid here
    assign q = data >> (idx << 2);

endmodule