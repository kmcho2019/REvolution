module adder_5bit (
    input [4:0] a,
    input [4:0] b,
    input cin,
    output [4:0] sum,
    output pg // propagate-generate
);
    wire [5:0] carry;
    assign carry[0] = cin;
    
    // Carry generation
    genvar i;
    generate
        for (i = 0; i < 5; i = i + 1) begin : bit_adder
            assign carry[i+1] = (a[i] & b[i]) | ((a[i] | b[i]) & carry[i]);
        end
    endgenerate
    
    assign sum = a ^ b ^ carry[4:0];
    
    // Block propagate-generate
    assign pg = (a == b); // All bits propagate when a == b
endmodule

module adder_6bit (
    input [5:0] a,
    input [5:0] b,
    input cin,
    output [5:0] sum,
    output pg // propagate-generate
);
    wire [6:0] carry;
    assign carry[0] = cin;
    
    // Carry generation
    genvar i;
    generate
        for (i = 0; i < 6; i = i + 1) begin : bit_adder
            assign carry[i+1] = (a[i] & b[i]) | ((a[i] | b[i]) & carry[i]);
        end
    endgenerate
    
    assign sum = a ^ b ^ carry[5:0];
    
    // Block propagate-generate
    assign pg = (a == b); // All bits propagate when a == b
endmodule

module adder_16bit (
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    wire carry1, carry2;
    wire pg1, pg2, pg3;
    
    // First 5-bit block (bits 0-4)
    adder_5bit block1 (
        .a(a[4:0]),
        .b(b[4:0]),
        .cin(Cin),
        .sum(y[4:0]),
        .pg(pg1)
    );
    
    // Carry skip logic between block1 and block2
    assign carry1 = (pg1 & Cin) | (~pg1 & carry1);
    
    // Middle 6-bit block (bits 5-10)
    adder_6bit block2 (
        .a(a[10:5]),
        .b(b[10:5]),
        .cin(carry1),
        .sum(y[10:5]),
        .pg(pg2)
    );
    
    // Carry skip logic between block2 and block3
    assign carry2 = (pg2 & carry1) | (~pg2 & carry2);
    
    // Final 5-bit block (bits 11-15)
    adder_5bit block3 (
        .a(a[15:11]),
        .b(b[15:11]),
        .cin(carry2),
        .sum(y[15:11]),
        .pg(pg3)
    );
    
    // Final carry out
    assign Co = (pg3 & carry2) | (~pg3 & carry3);
endmodule