module adder_pipe_64bit (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [63:0] adda,
    input wire [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

// Pipeline registers
reg [63:0] adda_reg, addb_reg;
reg [3:0] P_reg, G_reg;  // Group propagate/generate terms
reg [3:0] carry_reg;     // Intermediate carries
reg [15:0] sum0, sum1, sum2, sum3;  // Segment sums
reg en_stage1, en_stage2;

// CLA block outputs
wire [15:0] cla_sum [3:0];
wire [3:0] P, G;
wire [3:0] carry_out;

// Generate 16-bit CLA blocks
genvar i;
generate
    for (i = 0; i < 4; i = i + 1) begin : cla_blocks
        cla_16bit cla (
            .a(adda_reg[16*i+15 : 16*i]),
            .b(addb_reg[16*i+15 : 16*i]),
            .cin((i == 0) ? 1'b0 : carry_reg[i-1]),
            .sum(cla_sum[i]),
            .P(P[i]),
            .G(G[i])
        );
    end
endgenerate

// Carry computation between blocks
assign carry_out[0] = G[0] | (P[0] & 1'b0);  // No carry-in for first block
assign carry_out[1] = G[1] | (P[1] & carry_out[0]);
assign carry_out[2] = G[2] | (P[2] & carry_out[1]);
assign carry_out[3] = G[3] | (P[3] & carry_out[2]);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all registers
        adda_reg <= 64'b0;
        addb_reg <= 64'b0;
        P_reg <= 4'b0;
        G_reg <= 4'b0;
        carry_reg <= 4'b0;
        sum0 <= 16'b0;
        sum1 <= 16'b0;
        sum2 <= 16'b0;
        sum3 <= 16'b0;
        en_stage1 <= 1'b0;
        en_stage2 <= 1'b0;
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        // Stage 1: Register inputs and compute CLA sums
        adda_reg <= adda;
        addb_reg <= addb;
        P_reg <= P;
        G_reg <= G;
        en_stage1 <= i_en;
        
        // Stage 2: Compute final carries and assemble result
        carry_reg <= carry_out;
        sum0 <= cla_sum[0];
        sum1 <= cla_sum[1];
        sum2 <= cla_sum[2];
        sum3 <= cla_sum[3];
        en_stage2 <= en_stage1;
        
        // Final result assembly
        result <= {carry_out[3], sum3, sum2, sum1, sum0};
        o_en <= en_stage2;
    end
end

// 16-bit CLA submodule
module cla_16bit (
    input wire [15:0] a,
    input wire [15:0] b,
    input wire cin,
    output wire [15:0] sum,
    output wire P,
    output wire G
);
    wire [15:0] p, g;
    wire [15:0] carry;
    
    // Generate individual propagate/generate
    assign p = a | b;
    assign g = a & b;
    
    // Carry computation
    assign carry[0] = cin;
    assign carry[1] = g[0] | (p[0] & carry[0]);
    assign carry[2] = g[1] | (p[1] & carry[1]);
    assign carry[3] = g[2] | (p[2] & carry[2]);
    assign carry[4] = g[3] | (p[3] & carry[3]);
    assign carry[5] = g[4] | (p[4] & carry[4]);
    assign carry[6] = g[5] | (p[5] & carry[5]);
    assign carry[7] = g[6] | (p[6] & carry[6]);
    assign carry[8] = g[7] | (p[7] & carry[7]);
    assign carry[9] = g[8] | (p[8] & carry[8]);
    assign carry[10] = g[9] | (p[9] & carry[9]);
    assign carry[11] = g[10] | (p[10] & carry[10]);
    assign carry[12] = g[11] | (p[11] & carry[11]);
    assign carry[13] = g[12] | (p[12] & carry[12]);
    assign carry[14] = g[13] | (p[13] & carry[13]);
    assign carry[15] = g[14] | (p[14] & carry[14]);
    
    // Sum computation
    assign sum = a ^ b ^ carry;
    
    // Group propagate/generate
    assign P = &p;
    assign G = g[15] | (p[15] & g[14]) | (p[15] & p[14] & g[13]) |
               (p[15] & p[14] & p[13] & g[12]) | (p[15] & p[14] & p[13] & p[12] & g[11]) |
               (p[15] & p[14] & p[13] & p[12] & p[11] & g[10]) |
               (p[15] & p[14] & p[13] & p[12] & p[11] & p[10] & g[9]) |
               (p[15] & p[14] & p[13] & p[12] & p[11] & p[10] & p[9] & g[8]);
endmodule

endmodule