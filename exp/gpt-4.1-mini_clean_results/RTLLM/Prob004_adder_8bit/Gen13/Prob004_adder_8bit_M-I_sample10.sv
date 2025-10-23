// Simple 1-bit full adder module for sum calculation only (cin added)
// Carry output is not used here directly because carry is computed via CLA logic
module bit_full_adder (
    input  wire a,
    input  wire b,
    input  wire cin,
    output wire sum
);
    assign sum = a ^ b ^ cin;
endmodule

// 8-bit Carry Lookahead Adder (CLA)
module adder_8bit (
    input  wire [7:0] a,     // 8-bit operand A
    input  wire [7:0] b,     // 8-bit operand B
    input  wire       cin,   // carry-in input
    output wire [7:0] sum,   // 8-bit sum output
    output wire       cout   // carry-out output
);
    wire [7:0] p;    // propagate signals
    wire [7:0] g;    // generate signals
    wire [8:0] c;    // carry signals including c[0] = cin

    assign c[0] = cin;

    // Calculate propagate and generate for each bit
    assign p = a ^ b;      // propagate = a XOR b
    assign g = a & b;      // generate  = a AND b

    // Carry lookahead logic
    // Carry generation:
    // c[1] = g[0] | (p[0] & c[0])
    // c[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & c[0])
    // c[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & c[0])
    // ...
    assign c[1] = g[0] | (p[0] & c[0]);
    assign c[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & c[0]);
    assign c[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & c[0]);
    assign c[4] = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]) 
                  | (p[3] & p[2] & p[1] & p[0] & c[0]);
    assign c[5] = g[4] | (p[4] & g[3]) | (p[4] & p[3] & g[2]) | (p[4] & p[3] & p[2] & g[1]) 
                  | (p[4] & p[3] & p[2] & p[1] & g[0]) 
                  | (p[4] & p[3] & p[2] & p[1] & p[0] & c[0]);
    assign c[6] = g[5] | (p[5] & g[4]) | (p[5] & p[4] & g[3]) | (p[5] & p[4] & p[3] & g[2]) 
                  | (p[5] & p[4] & p[3] & p[2] & g[1]) 
                  | (p[5] & p[4] & p[3] & p[2] & p[1] & g[0])
                  | (p[5] & p[4] & p[3] & p[2] & p[1] & p[0] & c[0]);
    assign c[7] = g[6] | (p[6] & g[5]) | (p[6] & p[5] & g[4]) | (p[6] & p[5] & p[4] & g[3]) 
                  | (p[6] & p[5] & p[4] & p[3] & g[2]) 
                  | (p[6] & p[5] & p[4] & p[3] & p[2] & g[1]) 
                  | (p[6] & p[5] & p[4] & p[3] & p[2] & p[1] & g[0])
                  | (p[6] & p[5] & p[4] & p[3] & p[2] & p[1] & p[0] & c[0]);
    assign c[8] = g[7] | (p[7] & g[6]) | (p[7] & p[6] & g[5]) | (p[7] & p[6] & p[5] & g[4])
                  | (p[7] & p[6] & p[5] & p[4] & g[3])
                  | (p[7] & p[6] & p[5] & p[4] & p[3] & g[2])
                  | (p[7] & p[6] & p[5] & p[4] & p[3] & p[2] & g[1])
                  | (p[7] & p[6] & p[5] & p[4] & p[3] & p[2] & p[1] & g[0])
                  | (p[7] & p[6] & p[5] & p[4] & p[3] & p[2] & p[1] & p[0] & c[0]);

    // Instantiate the 1-bit full adders for sum bits (sum = p ^ c[i])
    genvar i;
    generate
        for (i=0; i<8; i=i+1) begin : sum_gen
            // sum[i] = a[i] ^ b[i] ^ c[i]
            bit_full_adder fa (
                .a(a[i]),
                .b(b[i]),
                .cin(c[i]),
                .sum(sum[i])
            );
        end
    endgenerate

    assign cout = c[8];
endmodule