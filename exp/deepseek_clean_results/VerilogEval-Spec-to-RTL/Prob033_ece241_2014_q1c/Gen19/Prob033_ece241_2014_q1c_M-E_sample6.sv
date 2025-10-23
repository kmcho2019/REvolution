module TopModule(
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);
    // Stage 1: Parallel generate and propagate computation
    wire [7:0] g = a & b;
    wire [7:0] p = a ^ b;
    
    // Stage 2: Carry-save computation (tree structure)
    wire [3:0] c_low, c_high;
    
    // Lower nibble carries
    assign c_low[0] = g[0];
    assign c_low[1] = g[1] | (p[1] & c_low[0]);
    assign c_low[2] = g[2] | (p[2] & c_low[1]);
    assign c_low[3] = g[3] | (p[3] & c_low[2]);
    
    // Upper nibble carries (parallel computation)
    assign c_high[0] = g[4];
    assign c_high[1] = g[5] | (p[5] & c_high[0]);
    assign c_high[2] = g[6] | (p[6] & c_high[1]);
    assign c_high[3] = g[7] | (p[7] & c_high[2]);
    
    // Final carry connection between nibbles
    wire carry_out = c_high[3];
    wire nibble_carry = g[4] | (p[4] & c_low[3]);
    
    // Early overflow detection
    wire potential_overflow = (a[7] == b[7]) && (p[7] != a[7]);
    assign overflow = potential_overflow & (carry_out ^ nibble_carry);
    
    // Sum computation
    assign s[3:0] = p[3:0] ^ {c_low[2:0], 1'b0};
    assign s[7:4] = p[7:4] ^ {c_high[2:0], nibble_carry};
endmodule