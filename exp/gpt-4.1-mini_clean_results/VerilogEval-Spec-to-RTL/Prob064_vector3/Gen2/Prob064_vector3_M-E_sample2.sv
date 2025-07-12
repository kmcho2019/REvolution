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

    // First, create three 10-bit vectors by pairing inputs
    wire [9:0] ab = {a, b};   // 5 bits a concatenated with 5 bits b
    wire [9:0] cd = {c, d};   // 5 bits c concatenated with 5 bits d
    wire [9:0] ef = {e, f};   // 5 bits e concatenated with 5 bits f

    // Combine these three 10-bit vectors into a 30-bit vector
    wire [29:0] thirty_bits = {ab, cd, ef};

    // Append two 1 bits at LSB positions to form a 32-bit vector
    wire [31:0] full_vector = {thirty_bits, 2'b11};

    // Split the full 32-bit vector into four 8-bit outputs
    assign w = full_vector[31:24];
    assign x = full_vector[23:16];
    assign y = full_vector[15:8];
    assign z = full_vector[7:0];

endmodule