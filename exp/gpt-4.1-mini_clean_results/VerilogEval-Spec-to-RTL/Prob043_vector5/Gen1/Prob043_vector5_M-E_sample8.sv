module TopModule(
    input  wire a,
    input  wire b,
    input  wire c,
    input  wire d,
    input  wire e,
    output wire [24:0] out
);
    // Define each pairwise equality explicitly
    wire [4:0] row_a = {~(a ^ a), ~(a ^ b), ~(a ^ c), ~(a ^ d), ~(a ^ e)};
    wire [4:0] row_b = {~(b ^ a), ~(b ^ b), ~(b ^ c), ~(b ^ d), ~(b ^ e)};
    wire [4:0] row_c = {~(c ^ a), ~(c ^ b), ~(c ^ c), ~(c ^ d), ~(c ^ e)};
    wire [4:0] row_d = {~(d ^ a), ~(d ^ b), ~(d ^ c), ~(d ^ d), ~(d ^ e)};
    wire [4:0] row_e = {~(e ^ a), ~(e ^ b), ~(e ^ c), ~(e ^ d), ~(e ^ e)};
    
    // Concatenate rows from a to e to form the output [24:0] as per problem spec
    assign out = {row_a, row_b, row_c, row_d, row_e};
endmodule