module TopModule(
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
    // Pack pairs of inputs into 10-bit wires
    wire [9:0] ab = {a, b};
    wire [9:0] cd = {c, d};
    // For ef, append two bits '11' at the LSB to form 12 bits total
    wire [11:0] ef_with_ones = {e, f, 2'b11};

    // Combine all groups into a 32-bit vector
    wire [31:0] combined = {ab, cd, ef_with_ones};

    // Assign to outputs by slicing combined vector into 8-bit chunks
    assign w = combined[31:24];
    assign x = combined[23:16];
    assign y = combined[15:8];
    assign z = combined[7:0];
endmodule