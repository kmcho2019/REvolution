module adder_pipe_64bit (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [63:0] adda,
    input wire [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

// Pipeline stage registers
reg [63:0] a_stage1, b_stage1;
reg [63:0] a_stage2, b_stage2;
reg [63:0] a_stage3, b_stage3;

// Propagate and Generate signals
wire [15:0] p0, p1, p2, p3;
wire [15:0] g0, g1, g2, g3;
reg [15:0] p0_reg, p1_reg, p2_reg, p3_reg;
reg [15:0] g0_reg, g1_reg, g2_reg, g3_reg;

// Carry signals
wire c16, c32, c48;
reg c16_reg, c32_reg, c48_reg;
wire c64;

// Intermediate sums
wire [15:0] sum0, sum1, sum2, sum3;
reg [15:0] sum0_reg, sum1_reg, sum2_reg, sum3_reg;

// Pipeline enable signals
reg en_stage1, en_stage2, en_stage3, en_stage4;

// Stage 1: Compute P & G for each 16-bit segment
assign p0 = adda[15:0]  ^ addb[15:0];
assign g0 = adda[15:0]  & addb[15:0];
assign p1 = adda[31:16] ^ addb[31:16];
assign g1 = adda[31:16] & addb[31:16];
assign p2 = adda[47:32] ^ addb[47:32];
assign g2 = adda[47:32] & addb[47:32];
assign p3 = adda[63:48] ^ addb[63:48];
assign g3 = adda[63:48] & addb[63:48];

// Stage 2: Carry lookahead computation
assign c16 = g0 | (p0 & 1'b0);
assign c32 = g1 | (p1 & g0) | (p1 & p0 & 1'b0);
assign c48 = g2 | (p2 & g1) | (p2 & p1 & g0) | (p2 & p1 & p0 & 1'b0);
assign c64 = g3 | (p3 & g2) | (p3 & p2 & g1) | (p3 & p2 & p1 & g0) | (p3 & p2 & p1 & p0 & 1'b0);

// Stage 3: Sum computation
assign sum0 = p0 ^ 1'b0;
assign sum1 = p1 ^ c16;
assign sum2 = p2 ^ c32;
assign sum3 = p3 ^ c48;

// Pipeline control
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all pipeline registers
        a_stage1 <= 64'b0; b_stage1 <= 64'b0;
        a_stage2 <= 64'b0; b_stage2 <= 64'b0;
        a_stage3 <= 64'b0; b_stage3 <= 64'b0;
        
        p0_reg <= 16'b0; p1_reg <= 16'b0; p2_reg <= 16'b0; p3_reg <= 16'b0;
        g0_reg <= 16'b0; g1_reg <= 16'b0; g2_reg <= 16'b0; g3_reg <= 16'b0;
        
        c16_reg <= 1'b0; c32_reg <= 1'b0; c48_reg <= 1'b0;
        sum0_reg <= 16'b0; sum1_reg <= 16'b0; sum2_reg <= 16'b0; sum3_reg <= 16'b0;
        
        en_stage1 <= 1'b0; en_stage2 <= 1'b0; en_stage3 <= 1'b0; en_stage4 <= 1'b0;
        result <= 65'b0;
        o_en <= 1'b0;
    end else begin
        // Pipeline stage 1
        a_stage1 <= adda;
        b_stage1 <= addb;
        en_stage1 <= i_en;
        
        // Pipeline stage 2
        a_stage2 <= a_stage1;
        b_stage2 <= b_stage1;
        p0_reg <= p0; p1_reg <= p1; p2_reg <= p2; p3_reg <= p3;
        g0_reg <= g0; g1_reg <= g1; g2_reg <= g2; g3_reg <= g3;
        en_stage2 <= en_stage1;
        
        // Pipeline stage 3
        a_stage3 <= a_stage2;
        b_stage3 <= b_stage2;
        c16_reg <= c16;
        c32_reg <= c32;
        c48_reg <= c48;
        en_stage3 <= en_stage2;
        
        // Pipeline stage 4
        sum0_reg <= sum0;
        sum1_reg <= sum1;
        sum2_reg <= sum2;
        sum3_reg <= sum3;
        en_stage4 <= en_stage3;
        
        // Final output
        if (en_stage4) begin
            result <= {c64, sum3_reg, sum2_reg, sum1_reg, sum0_reg};
            o_en <= 1'b1;
        end else begin
            o_en <= 1'b0;
        end
    end
end

endmodule