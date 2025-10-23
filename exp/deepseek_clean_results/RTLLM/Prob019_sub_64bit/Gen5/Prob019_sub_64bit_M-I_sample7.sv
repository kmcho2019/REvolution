module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output signed [63:0] result,
    output overflow
);

wire [63:0] B_comp = ~B + 1'b1;  // Two's complement of B
wire [15:0] carry;

// 4-bit carry-lookahead adder blocks
genvar i;
generate
    for (i = 0; i < 16; i = i + 1) begin : adder_block
        wire [3:0] a = A[i*4 +: 4];
        wire [3:0] b = B_comp[i*4 +: 4];
        wire [3:0] sum;
        wire cout;
        
        if (i == 0) begin
            cla_4bit adder (
                .a(a),
                .b(b),
                .cin(1'b0),
                .sum(sum),
                .cout(cout)
            );
        end else begin
            cla_4bit adder (
                .a(a),
                .b(b),
                .cin(carry[i-1]),
                .sum(sum),
                .cout(cout)
            );
        end
        
        assign carry[i] = cout;
        assign result[i*4 +: 4] = sum;
    end
endgenerate

// Optimized overflow detection
wire sign_a = A[63];
wire sign_b = B[63];
wire sign_r = result[63];
wire cout_63 = carry[15];

assign overflow = (~sign_a & sign_b & sign_r) |  // Positive overflow
                  (sign_a & ~sign_b & ~sign_r) | // Negative overflow
                  (sign_a ^ sign_b) & (sign_b ^ cout_63); // Alternative detection

endmodule

// 4-bit carry-lookahead adder module
module cla_4bit (
    input [3:0] a,
    input [3:0] b,
    input cin,
    output [3:0] sum,
    output cout
);
    wire [3:0] g = a & b;
    wire [3:0] p = a | b;
    
    wire c1 = g[0] | (p[0] & cin);
    wire c2 = g[1] | (p[1] & g[0]) | (p[1] & p[0] & cin);
    wire c3 = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & cin);
    wire c4 = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]) | 
              (p[3] & p[2] & p[1] & p[0] & cin);
    
    assign sum[0] = a[0] ^ b[0] ^ cin;
    assign sum[1] = a[1] ^ b[1] ^ c1;
    assign sum[2] = a[2] ^ b[2] ^ c2;
    assign sum[3] = a[3] ^ b[3] ^ c3;
    assign cout = c4;
endmodule