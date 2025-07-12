module adder_4bit_cla (
    input [3:0] a,
    input [3:0] b,
    input cin,
    output [3:0] sum,
    output cout
);
    wire [3:0] p, g;
    wire [4:1] c;
    
    // Generate and propagate terms
    assign p = a ^ b;
    assign g = a & b;
    
    // Carry lookahead logic
    assign c[1] = g[0] | (p[0] & cin);
    assign c[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & cin);
    assign c[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & cin);
    assign c[4] = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]) | 
                  (p[3] & p[2] & p[1] & p[0] & cin);
    
    // Sum calculation
    assign sum = p ^ {c[3:1], cin};
    assign cout = c[4];
endmodule

module adder_16bit (
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    wire [3:0] carry;
    wire [15:0] sum0, sum1;
    
    // First 4-bit block (always computed)
    adder_4bit_cla block0 (
        .a(a[3:0]),
        .b(b[3:0]),
        .cin(Cin),
        .sum(y[3:0]),
        .cout(carry[0])
    );
    
    // Generate two possible sums for next blocks (carry=0 and carry=1)
    // Block 1 (bits 7:4)
    adder_4bit_cla block1_0 (
        .a(a[7:4]),
        .b(b[7:4]),
        .cin(1'b0),
        .sum(sum0[7:4]),
        .cout(carry[1])
    );
    adder_4bit_cla block1_1 (
        .a(a[7:4]),
        .b(b[7:4]),
        .cin(1'b1),
        .sum(sum1[7:4]),
        .cout(carry[2])
    );
    
    // Block 2 (bits 11:8)
    adder_4bit_cla block2_0 (
        .a(a[11:8]),
        .b(b[11:8]),
        .cin(1'b0),
        .sum(sum0[11:8]),
        .cout(carry[3])
    );
    adder_4bit_cla block2_1 (
        .a(a[11:8]),
        .b(b[11:8]),
        .cin(1'b1),
        .sum(sum1[11:8]),
        .cout()
    );
    
    // Block 3 (bits 15:12)
    adder_4bit_cla block3_0 (
        .a(a[15:12]),
        .b(b[15:12]),
        .cin(1'b0),
        .sum(sum0[15:12]),
        .cout()
    );
    adder_4bit_cla block3_1 (
        .a(a[15:12]),
        .b(b[15:12]),
        .cin(1'b1),
        .sum(sum1[15:12]),
        .cout()
    );
    
    // Carry-select muxes
    assign y[7:4] = carry[0] ? sum1[7:4] : sum0[7:4];
    wire carry1 = carry[0] ? carry[2] : carry[1];
    
    assign y[11:8] = carry1 ? sum1[11:8] : sum0[11:8];
    wire carry2 = carry1 ? carry[3] : carry[3];
    
    assign y[15:12] = carry2 ? sum1[15:12] : sum0[15:12];
    assign Co = carry2;
endmodule