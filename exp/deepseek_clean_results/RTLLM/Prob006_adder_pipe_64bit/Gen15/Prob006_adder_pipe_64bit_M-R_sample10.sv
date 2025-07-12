module adder_pipe_64bit (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [63:0] adda,
    input wire [63:0] addb,
    output wire [64:0] result,
    output reg o_en
);

// Pipeline stage 1 signals
reg [31:0] stage1_a_lo, stage1_b_lo;
reg stage1_en;
wire [32:0] stage1_sum = {1'b0, stage1_a_lo} + {1'b0, stage1_b_lo};

// Pipeline stage 2 signals
reg [31:0] stage2_a_hi, stage2_b_hi;
reg stage2_carry;
reg stage2_en;
wire [32:0] stage2_sum = {1'b0, stage2_a_hi} + {1'b0, stage2_b_hi} + stage2_carry;

// Output assignments
assign result = {stage2_sum, stage1_sum[31:0]};

// Enable signal pipeline
wire next_stage1_en = i_en;
wire next_stage2_en = stage1_en;
wire next_o_en = stage2_en;

// Pipeline registers
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Stage 1 registers
        stage1_a_lo <= 32'b0;
        stage1_b_lo <= 32'b0;
        stage1_en <= 1'b0;
        
        // Stage 2 registers
        stage2_a_hi <= 32'b0;
        stage2_b_hi <= 32'b0;
        stage2_carry <= 1'b0;
        stage2_en <= 1'b0;
        
        // Output register
        o_en <= 1'b0;
    end else begin
        // Stage 1 update
        stage1_a_lo <= adda[31:0];
        stage1_b_lo <= addb[31:0];
        stage1_en <= next_stage1_en;
        
        // Stage 2 update
        stage2_a_hi <= adda[63:32];
        stage2_b_hi <= addb[63:32];
        stage2_carry <= stage1_sum[32];
        stage2_en <= next_stage2_en;
        
        // Output update
        o_en <= next_o_en;
    end
end

endmodule