/**
 * Optimized 8-bit Carry Lookahead Adder with parameterized width
 * Uses 4-bit lookahead groups for improved timing
 * Implements hierarchical carry generation
 */
module adder_8bit #(
    parameter WIDTH = 8      // Default to 8-bit width
) (
    input [WIDTH-1:0] a,    // Operand A
    input [WIDTH-1:0] b,    // Operand B
    input cin,              // Carry-in
    output [WIDTH-1:0] sum, // Sum output
    output cout             // Carry-out
);

    // Generate and propagate signals for each bit
    wire [WIDTH-1:0] g, p;
    wire [WIDTH:0] carry;
    
    // First level: Bitwise generate and propagate
    assign carry[0] = cin;
    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : bit_logic
            assign g[i] = a[i] & b[i];          // Generate
            assign p[i] = a[i] ^ b[i];          // Propagate
            assign sum[i] = p[i] ^ carry[i];     // Sum
        end
    endgenerate
    
    // Second level: 4-bit lookahead carry units
    wire [1:0] gg, pg;  // Group generate/propagate
    wire [1:0] c_group;  // Group carries
    
    // First 4-bit group
    assign gg[0] = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]);
    assign pg[0] = p[3] & p[2] & p[1] & p[0];
    assign c_group[0] = g[0] | (p[0] & carry[0]);
    assign carry[1] = g[0] | (p[0] & carry[0]);
    assign carry[2] = g[1] | (p[1] & carry[1]);
    assign carry[3] = g[2] | (p[2] & carry[2]);
    assign carry[4] = gg[0] | (pg[0] & carry[0]);
    
    // Second 4-bit group
    assign gg[1] = g[7] | (p[7] & g[6]) | (p[7] & p[6] & g[5]) | (p[7] & p[6] & p[5] & g[4]);
    assign pg[1] = p[7] & p[6] & p[5] & p[4];
    assign carry[5] = g[4] | (p[4] & carry[4]);
    assign carry[6] = g[5] | (p[5] & carry[5]);
    assign carry[7] = g[6] | (p[6] & carry[6]);
    assign carry[8] = gg[1] | (pg[1] & carry[4]);
    
    assign cout = carry[WIDTH];

endmodule