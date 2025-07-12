module TopModule(
    input  [3:0] a,
    input  [3:0] b,
    input  [3:0] c,
    input  [3:0] d,
    input  [3:0] e,
    output [3:0] q
);

    // Concatenate inputs and fixed default value for out-of-range selections
    wire [19:0] data = {4'hF, d, a, e, b};

    // Clamp c to maximum 4 to avoid out-of-bounds indexing
    wire [3:0] c_clamped = (c > 4'd4) ? 4'd4 : c;

    // Compute bit offset by shifting clamped index left by 2 (multiply by 4)
    wire [4:0] bit_offset = c_clamped << 2;

    // Extract 4 bits starting at bit_offset
    assign q = (data >> bit_offset) & 4'hF;

endmodule