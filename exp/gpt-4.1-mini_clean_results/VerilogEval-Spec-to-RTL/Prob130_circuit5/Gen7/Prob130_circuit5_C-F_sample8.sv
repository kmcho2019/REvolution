module TopModule(
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [3:0] e,
    output [3:0] q
);

    // Concatenate inputs and default constant 4'hF into a 20-bit ROM-like vector
    // Index 0: b, 1: e, 2: a, 3: d, 4: 4'hF
    wire [19:0] data = {4'hF, d, a, e, b};

    // Clamp c to max 4 to avoid out-of-range indexing
    wire [2:0] idx = (c > 4) ? 3'd4 : c[2:0];

    // Extract 4-bit slice using shift right by idx*4 bits
    // Use shift left in constant indices to avoid multiplication by 4
    // Assign q by slicing 4 bits starting from idx*4
    assign q = data >> (idx << 2);

endmodule