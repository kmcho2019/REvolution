module adder_pipe_64bit #(
    parameter PIPELINE_DEPTH = 4
) (
    input wire clk,
    input wire rst_n,
    input wire i_en,
    input wire [63:0] adda,
    input wire [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

// Configuration checks
initial begin
    if (PIPELINE_DEPTH < 1 || PIPELINE_DEPTH > 4) 
        $error("Pipeline depth must be between 1 and 4");
end

// Pipeline control signals
reg [PIPELINE_DEPTH-1:0] stage_valid;
wire [PIPELINE_DEPTH-1:0] next_stage_valid = {stage_valid[PIPELINE_DEPTH-2:0], i_en};

// Dual-edge registers
reg [63:0] a_ff, b_ff;
always @(posedge clk or negedge clk or negedge rst_n) begin
    if (!rst_n) begin
        a_ff <= 64'b0;
        b_ff <= 64'b0;
    end else if (i_en) begin
        a_ff <= adda;
        b_ff <= addb;
    end
end

// Stage 1: 16-bit block processing
reg [3:0] block_propagate [0:3];
reg [3:0] block_generate [0:3];
reg [15:0] block_sum [0:3];
reg [3:0] stage1_parity;

generate
    for (genvar i = 0; i < 4; i = i + 1) begin : block_gen
        always @(posedge clk or negedge rst_n) begin
            if (!rst_n) begin
                block_propagate[i] <= 1'b0;
                block_generate[i] <= 1'b0;
                block_sum[i] <= 16'b0;
            end else if (stage_valid[0]) begin
                block_sum[i] <= a_ff[i*16+15:i*16] + b_ff[i*16+15:i*16];
                block_propagate[i] <= ^(a_ff[i*16+15:i*16] | b_ff[i*16+15:i*16]);
                block_generate[i] <= ^(a_ff[i*16+15:i*16] & b_ff[i*16+15:i*16]);
            end
        end
    end
endgenerate

// Stage 1 parity check
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) stage1_parity <= 4'b0;
    else if (stage_valid[0]) stage1_parity <= ^{a_ff, b_ff};
end

// Stage 2: Supergroup carry lookahead
reg [3:0] super_carry;
reg [3:0] stage2_parity;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        super_carry <= 4'b0;
        stage2_parity <= 4'b0;
    end else if (stage_valid[1]) begin
        // Carry lookahead logic
        super_carry[0] <= block_generate[0];
        super_carry[1] <= block_generate[1] | (block_propagate[1] & block_generate[0]);
        super_carry[2] <= block_generate[2] | (block_propagate[2] & block_generate[1]) | 
                         (block_propagate[2] & block_propagate[1] & block_generate[0]);
        super_carry[3] <= block_generate[3] | (block_propagate[3] & block_generate[2]) |
                         (block_propagate[3] & block_propagate[2] & block_generate[1]) |
                         (block_propagate[3] & block_propagate[2] & block_propagate[1] & block_generate[0]);
        stage2_parity <= stage1_parity;
    end
end

// Stage 3: Final carry resolution
reg [3:0] final_carry;
reg [3:0] stage3_parity;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        final_carry <= 4'b0;
        stage3_parity <= 4'b0;
    end else if (stage_valid[2]) begin
        final_carry <= super_carry;
        stage3_parity <= stage2_parity;
    end
end

// Stage 4: Sum combination and output
reg [64:0] final_sum;
reg error_flag;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        final_sum <= 65'b0;
        error_flag <= 1'b0;
        o_en <= 1'b0;
        stage_valid <= 0;
    end else begin
        stage_valid <= next_stage_valid;
        
        if (stage_valid[3]) begin
            // Combine results with carries
            final_sum[15:0] <= block_sum[0];
            final_sum[31:16] <= block_sum[1] + final_carry[0];
            final_sum[47:32] <= block_sum[2] + final_carry[1];
            final_sum[63:48] <= block_sum[3] + final_carry[2];
            final_sum[64] <= final_carry[3];
            
            // Error detection
            error_flag <= (^{final_sum, stage3_parity} != 0);
            o_en <= 1'b1;
        end else begin
            o_en <= 1'b0;
        end
    end
end

assign result = error_flag ? 65'h1FFFFFFFFFFFFFFFF : final_sum;

endmodule