module TopModule(
    input [7:0] a,
    input [7:0] b,
    input enable,  // Added for power optimization
    output [7:0] s,
    output overflow
);
    wire [7:0] a_gated = enable ? a : 8'b0;
    wire [7:0] b_gated = enable ? b : 8'b0;
    
    // Carry-lookahead adder implementation (4-bit blocks)
    wire [1:0] g, p, c;
    assign c[0] = 1'b0;
    
    // First 4-bit block
    wire [3:0] s_low;
    cla_4bit cla_low (
        .a(a_gated[3:0]),
        .b(b_gated[3:0]),
        .cin(c[0]),
        .sum(s_low),
        .gout(g[0]),
        .pout(p[0])
    );
    
    // Carry lookahead logic
    assign c[1] = g[0] | (p[0] & c[0]);
    
    // Second 4-bit block
    wire [3:0] s_high;
    cla_4bit cla_high (
        .a(a_gated[7:4]),
        .b(b_gated[7:4]),
        .cin(c[1]),
        .sum(s_high),
        .gout(g[1]),
        .pout(p[1])
    );
    
    // Final sum assignment
    assign s = enable ? {s_high, s_low} : 8'b0;
    
    // Shared XOR for overflow and sign comparison
    wire sign_xor = a_gated[7] ^ b_gated[7];
    wire sum_sign_xor = a_gated[7] ^ s[7];
    assign overflow = enable ? (~sign_xor & sum_sign_xor) : 1'b0;
endmodule

// 4-bit carry-lookahead adder module
module cla_4bit(
    input [3:0] a,
    input [3:0] b,
    input cin,
    output [3:0] sum,
    output gout,
    output pout
);
    wire [3:0] g = a & b;
    wire [3:0] p = a ^ b;
    
    wire [3:1] c;
    assign c[1] = g[0] | (p[0] & cin);
    assign c[2] = g[1] | (p[1] & c[1]);
    assign c[3] = g[2] | (p[2] & c[2]);
    
    assign sum[0] = p[0] ^ cin;
    assign sum[1] = p[1] ^ c[1];
    assign sum[2] = p[2] ^ c[2];
    assign sum[3] = p[3] ^ c[3];
    
    assign gout = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]);
    assign pout = p[3] & p[2] & p[1] & p[0];
endmodule