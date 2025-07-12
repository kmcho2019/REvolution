module TopModule(
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [3:0] e,
    output [3:0] q
);

    // Concatenate the 5 possible outputs: b, e, a, d, 4'hF (from LSB to MSB)
    wire [19:0] data = {4'hF, d, a, e, b};

    // Clamp c to max 4 for indexing (5 elements: indices 0 to 4)
    wire [2:0] idx = (c < 5) ? c[2:0] : 3'd4;

    // Select corresponding nibble by shifting right by idx*4 bits
    // Replace multiplication by shift: idx*4 == idx << 2
    assign q = (data >> (idx << 2)) & 4'hF;

endmodule