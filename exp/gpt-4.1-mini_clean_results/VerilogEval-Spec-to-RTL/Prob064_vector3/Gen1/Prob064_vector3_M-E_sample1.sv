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

    // Combine inputs in pairs
    wire [9:0] ab = {a, b};    // 5+5=10 bits
    wire [9:0] cd = {c, d};
    wire [9:0] ef = {e, f};

    // Append two LSB 1 bits to ef to form 12 bits
    wire [11:0] ef_padded = {ef, 2'b11};

    // Concatenate ab, cd, ef_padded to form 32 bits
    wire [31:0] combined = {ab, cd, ef_padded};

    // Split into four 8-bit outputs (MSB to LSB)
    assign w = combined[31:24];
    assign x = combined[23:16];
    assign y = combined[15:8];
    assign z = combined[7:0];

endmodule