module adder_8bit #(
    parameter WIDTH = 8
) (
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    input cin,
    output [WIDTH-1:0] sum,
    output cout
);

    // Group carry lookahead (4-bit groups)
    wire [1:0] group_propagate;
    wire [1:0] group_generate;
    wire [1:0] group_carry;
    
    assign group_carry[0] = cin;
    
    // First 4-bit block
    adder_4bit_lookahead block0 (
        .a(a[3:0]),
        .b(b[3:0]),
        .cin(group_carry[0]),
        .sum(sum[3:0]),
        .propagate(group_propagate[0]),
        .generate(group_generate[0])
    );
    
    // Second 4-bit block
    adder_4bit_lookahead block1 (
        .a(a[7:4]),
        .b(b[7:4]),
        .cin(group_carry[1]),
        .sum(sum[7:4]),
        .propagate(group_propagate[1]),
        .generate(group_generate[1])
    );
    
    // Carry lookahead between groups
    assign group_carry[1] = group_generate[0] | (group_propagate[0] & group_carry[0]);
    assign cout = group_generate[1] | (group_propagate[1] & group_carry[1]);

endmodule

module adder_4bit_lookahead (
    input [3:0] a,
    input [3:0] b,
    input cin,
    output [3:0] sum,
    output propagate,
    output generate
);
    
    wire [3:0] p, g;
    wire [3:1] c;
    
    // Generate and propagate terms
    assign p = a ^ b;
    assign g = a & b;
    
    // Carry lookahead
    assign c[1] = g[0] | (p[0] & cin);
    assign c[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & cin);
    assign c[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & cin);
    
    // Sum generation
    assign sum[0] = p[0] ^ cin;
    assign sum[1] = p[1] ^ c[1];
    assign sum[2] = p[2] ^ c[2];
    assign sum[3] = p[3] ^ c[3];
    
    // Group propagate and generate
    assign propagate = &p;  // All propagate bits are 1
    assign generate = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]);

endmodule