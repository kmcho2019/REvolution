module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output signed [63:0] result,
    output overflow
);

wire [63:0] B_comp = ~B + 1'b1;  // Two's complement of B
wire cout;  // Final carry out

// Carry-lookahead adder implementation for A + (-B)
cla_64bit adder (
    .A(A),
    .B(B_comp),
    .cin(1'b0),
    .sum(result),
    .cout(cout)
);

// Optimized overflow detection
assign overflow = (A[63] ^ B[63]) & (A[63] ^ result[63]);

endmodule

// 64-bit carry-lookahead adder module
module cla_64bit (
    input [63:0] A,
    input [63:0] B,
    input cin,
    output [63:0] sum,
    output cout
);

wire [15:0] c;
wire [15:0] g;
wire [15:0] p;

// Generate 4-bit CLA blocks
genvar i;
generate
    for (i = 0; i < 16; i = i + 1) begin : cla_block
        cla_4bit block (
            .A(A[i*4+3:i*4]),
            .B(B[i*4+3:i*4]),
            .cin((i == 0) ? cin : c[i-1]),
            .sum(sum[i*4+3:i*4]),
            .cout(c[i]),
            .g(g[i]),
            .p(p[i])
        );
    end
endgenerate

// Carry lookahead logic
assign cout = c[15];

endmodule

// 4-bit CLA building block
module cla_4bit (
    input [3:0] A,
    input [3:0] B,
    input cin,
    output [3:0] sum,
    output cout,
    output g,
    output p
);

wire [3:0] G = A & B;
wire [3:0] P = A ^ B;

wire c1 = G[0] | (P[0] & cin);
wire c2 = G[1] | (P[1] & G[0]) | (P[1] & P[0] & cin);
wire c3 = G[2] | (P[2] & G[1]) | (P[2] & P[1] & G[0]) | (P[2] & P[1] & P[0] & cin);
wire c4 = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]) | 
          (P[3] & P[2] & P[1] & P[0] & cin);

assign sum[0] = P[0] ^ cin;
assign sum[1] = P[1] ^ c1;
assign sum[2] = P[2] ^ c2;
assign sum[3] = P[3] ^ c3;
assign cout = c4;

assign g = G[3] | (P[3] & G[2]) | (P[3] & P[2] & G[1]) | (P[3] & P[2] & P[1] & G[0]);
assign p = P[3] & P[2] & P[1] & P[0];

endmodule