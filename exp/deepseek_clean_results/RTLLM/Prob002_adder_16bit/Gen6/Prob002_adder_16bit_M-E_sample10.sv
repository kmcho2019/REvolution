module adder_4bit (
    input [3:0] a,
    input [3:0] b,
    input cin,
    output [3:0] sum,
    output cout
);
    wire [3:0] g = a & b;  // generate
    wire [3:0] p = a ^ b;  // propagate
    wire [3:0] c;
    
    assign c[0] = cin;
    assign c[1] = g[0] | (p[0] & c[0]);
    assign c[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & c[0]);
    assign c[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | 
                 (p[2] & p[1] & p[0] & c[0]);
    
    assign sum = p ^ c;
    assign cout = g[3] | (p[3] & c[3]);
endmodule

module adder_16bit (
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    wire [3:0] c;
    wire [3:0] sum0, sum1;
    wire [3:0] sum2_0, sum2_1;
    wire [3:0] sum3_0, sum3_1;
    wire [3:0] sum4_0, sum4_1;
    
    // First 4-bit block (ripple carry)
    adder_4bit block1 (
        .a(a[3:0]),
        .b(b[3:0]),
        .cin(Cin),
        .sum(y[3:0]),
        .cout(c[0])
    );
    
    // Second 4-bit block (carry-select)
    adder_4bit block2_0 (
        .a(a[7:4]),
        .b(b[7:4]),
        .cin(1'b0),
        .sum(sum2_0),
        .cout()
    );
    
    adder_4bit block2_1 (
        .a(a[7:4]),
        .b(b[7:4]),
        .cin(1'b1),
        .sum(sum2_1),
        .cout()
    );
    
    assign y[7:4] = c[0] ? sum2_1 : sum2_0;
    assign c[1] = c[0] ? 
        (a[7] & b[7]) | ((a[7] ^ b[7]) & (a[6] & b[6])) | 
        ((a[7] ^ b[7]) & (a[6] ^ b[6]) & (a[5] & b[5])) | 
        ((a[7] ^ b[7]) & (a[6] ^ b[6]) & (a[5] ^ b[5]) & (a[4] & b[4])) |
        ((a[7] ^ b[7]) & (a[6] ^ b[6]) & (a[5] ^ b[5]) & (a[4] ^ b[4]))) :
        (a[7] & b[7]) | ((a[7] ^ b[7]) & (a[6] & b[6])) | 
        ((a[7] ^ b[7]) & (a[6] ^ b[6]) & (a[5] & b[5])) | 
        ((a[7] ^ b[7]) & (a[6] ^ b[6]) & (a[5] ^ b[5]) & (a[4] & b[4])));
    
    // Third 4-bit block (carry-select)
    adder_4bit block3_0 (
        .a(a[11:8]),
        .b(b[11:8]),
        .cin(1'b0),
        .sum(sum3_0),
        .cout()
    );
    
    adder_4bit block3_1 (
        .a(a[11:8]),
        .b(b[11:8]),
        .cin(1'b1),
        .sum(sum3_1),
        .cout()
    );
    
    assign y[11:8] = c[1] ? sum3_1 : sum3_0;
    assign c[2] = c[1] ? 
        (a[11] & b[11]) | ((a[11] ^ b[11]) & (a[10] & b[10])) | 
        ((a[11] ^ b[11]) & (a[10] ^ b[10]) & (a[9] & b[9])) | 
        ((a[11] ^ b[11]) & (a[10] ^ b[10]) & (a[9] ^ b[9]) & (a[8] & b[8])) |
        ((a[11] ^ b[11]) & (a[10] ^ b[10]) & (a[9] ^ b[9]) & (a[8] ^ b[8]))) :
        (a[11] & b[11]) | ((a[11] ^ b[11]) & (a[10] & b[10])) | 
        ((a[11] ^ b[11]) & (a[10] ^ b[10]) & (a[9] & b[9])) | 
        ((a[11] ^ b[11]) & (a[10] ^ b[10]) & (a[9] ^ b[9]) & (a[8] & b[8]));
    
    // Fourth 4-bit block (carry-select)
    adder_4bit block4_0 (
        .a(a[15:12]),
        .b(b[15:12]),
        .cin(1'b0),
        .sum(sum4_0),
        .cout()
    );
    
    adder_4bit block4_1 (
        .a(a[15:12]),
        .b(b[15:12]),
        .cin(1'b1),
        .sum(sum4_1),
        .cout()
    );
    
    assign y[15:12] = c[2] ? sum4_1 : sum4_0;
    assign Co = c[2] ? 
        (a[15] & b[15]) | ((a[15] ^ b[15]) & (a[14] & b[14])) | 
        ((a[15] ^ b[15]) & (a[14] ^ b[14]) & (a[13] & b[13])) | 
        ((a[15] ^ b[15]) & (a[14] ^ b[14]) & (a[13] ^ b[13]) & (a[12] & b[12])) |
        ((a[15] ^ b[15]) & (a[14] ^ b[14]) & (a[13] ^ b[13]) & (a[12] ^ b[12]))) :
        (a[15] & b[15]) | ((a[15] ^ b[15]) & (a[14] & b[14])) | 
        ((a[15] ^ b[15]) & (a[14] ^ b[14]) & (a[13] & b[13])) | 
        ((a[15] ^ b[15]) & (a[14] ^ b[14]) & (a[13] ^ b[13]) & (a[12] & b[12]));
endmodule