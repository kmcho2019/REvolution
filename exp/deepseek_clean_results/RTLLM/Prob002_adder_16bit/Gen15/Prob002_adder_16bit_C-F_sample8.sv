module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);
    // Optimized carry generation with minimal logic levels
    wire [7:0] g = a & b;  // Generate terms
    wire [7:0] p = a | b;  // Propagate terms
    wire [8:0] carry;
    
    assign carry[0] = cin;
    assign carry[1] = g[0] | (p[0] & carry[0]);
    assign carry[2] = g[1] | (p[1] & carry[1]);
    assign carry[3] = g[2] | (p[2] & carry[2]);
    assign carry[4] = g[3] | (p[3] & carry[3]);
    assign carry[5] = g[4] | (p[4] & carry[4]);
    assign carry[6] = g[5] | (p[5] & carry[5]);
    assign carry[7] = g[6] | (p[6] & carry[6]);
    assign carry[8] = g[7] | (p[7] & carry[7]);
    
    // Efficient sum calculation using XOR
    assign sum = a ^ b ^ carry[7:0];
    assign cout = carry[8];
endmodule

module adder_16bit (
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    // Intermediate carry signal
    wire carry_mid;
    
    // Lower 8-bit adder (LSBs)
    adder_8bit adder_low (
        .a(a[7:0]),
        .b(b[7:0]),
        .cin(Cin),
        .sum(y[7:0]),
        .cout(carry_mid)
    );
    
    // Upper 8-bit adder (MSBs)
    adder_8bit adder_high (
        .a(a[15:8]),
        .b(b[15:8]),
        .cin(carry_mid),
        .sum(y[15:8]),
        .cout(Co)
    );
endmodule