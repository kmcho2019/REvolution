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

    // Intermediate 15-bit wires for better modularity and readability
    wire [14:0] first_half = {a, b, c};   // 5 + 5 + 5 = 15 bits
    wire [14:0] second_half = {d, e, f};  // 5 + 5 + 5 = 15 bits

    // Combined 32-bit wire: concatenation of all inputs plus two appended '1' bits (LSB)
    wire [31:0] combined = {first_half, second_half, 2'b11};

    // Explicit slicing of the combined vector into four 8-bit outputs
    assign w = combined[31:24];
    assign x = combined[23:16];
    assign y = combined[15:8];
    assign z = combined[7:0];

endmodule