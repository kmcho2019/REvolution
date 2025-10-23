module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);
    // Bit-level generate/propagate
    wire [7:0] g = a & b;
    wire [7:0] p = a ^ b;
    
    // 4-bit block generate/propagate
    wire g_low4 = g[3] | (p[3] & (g[2] | (p[2] & (g[1] | (p[1] & g[0])))));
    wire p_low4 = p[3] & p[2] & p[1] & p[0];
    wire g_high4 = g[7] | (p[7] & (g[6] | (p[6] & (g[5] | (p[5] & g[4])))));
    wire p_high4 = p[7] & p[6] & p[5] & p[4];
    
    // Block carry computation
    wire carry4 = g_low4 | (p_low4 & cin);
    wire carry8 = g_high4 | (p_high4 & carry4);
    
    // Bit carry computation
    wire [7:0] carry;
    assign carry[0] = cin;
    assign carry[1] = g[0] | (p[0] & carry[0]);
    assign carry[2] = g[1] | (p[1] & carry[1]);
    assign carry[3] = g[2] | (p[2] & carry[2]);
    assign carry[4] = carry4;
    assign carry[5] = g[4] | (p[4] & carry[4]);
    assign carry[6] = g[5] | (p[5] & carry[5]);
    assign carry[7] = g[6] | (p[6] & carry[6]);
    
    // Sum and output
    assign sum = p ^ carry[7:0];
    assign cout = carry8;
endmodule

module adder_16bit (
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    // Block propagate/generate between 8-bit adders
    wire [7:0] g0 = a[7:0] & b[7:0];
    wire [7:0] p0 = a[7:0] ^ b[7:0];
    wire g_low8 = g0[7] | (p0[7] & (g0[6] | (p0[6] & (g0[5] | (p0[5] & 
                  (g0[4] | (p0[4] & (g0[3] | (p0[3] & (g0[2] | (p0[2] & 
                  (g0[1] | (p0[1] & g0[0])))))))))));
    wire p_low8 = &p0;
    
    wire carry_middle = g_low8 | (p_low8 & Cin);
    
    // Instantiate adders with optimized carry
    adder_8bit lower_adder (
        .a(a[7:0]),
        .b(b[7:0]),
        .cin(Cin),
        .sum(y[7:0]),
        .cout()  // unused as we compute carry_middle directly
    );
    
    adder_8bit upper_adder (
        .a(a[15:8]),
        .b(b[15:8]),
        .cin(carry_middle),
        .sum(y[15:8]),
        .cout(Co)
    );
endmodule