module multi_pipe_8bit (
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output reg mul_en_out,
    output reg [15:0] mul_out
);

// Parameters for easy modification
parameter WIDTH = 8;
parameter PP_STAGES = 4;

// Input stage registers
reg [WIDTH-1:0] stage1_a, stage1_b;
reg stage1_en;

// Partial products
wire [WIDTH-1:0] pp [WIDTH-1:0];

// Generate all partial products systematically
genvar i;
generate
    for (i = 0; i < WIDTH; i = i + 1) begin : pp_gen
        assign pp[i] = stage1_b[i] ? stage1_a : {WIDTH{1'b0}};
    end
endgenerate

// Pipeline stage 2 registers (first adder level)
reg [15:0] stage2_sum01, stage2_sum23, stage2_sum45, stage2_sum67;
reg stage2_en;

// Pipeline stage 3 registers (second adder level)
reg [15:0] stage3_sum0123, stage3_sum4567;
reg stage3_en;

// Pipeline stage 4 registers (final adder)
reg [15:0] stage4_sum;
reg stage4_en;

// Input stage pipeline
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage1_a <= {WIDTH{1'b0}};
        stage1_b <= {WIDTH{1'b0}};
        stage1_en <= 1'b0;
    end else begin
        stage1_en <= mul_en_in;
        if (mul_en_in) begin
            stage1_a <= mul_a;
            stage1_b <= mul_b;
        end
    end
end

// First adder stage pipeline
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage2_sum01 <= 16'b0;
        stage2_sum23 <= 16'b0;
        stage2_sum45 <= 16'b0;
        stage2_sum67 <= 16'b0;
        stage2_en <= 1'b0;
    end else begin
        stage2_en <= stage1_en;
        stage2_sum01 <= {8'b0, pp[0]} + {7'b0, pp[1], 1'b0};
        stage2_sum23 <= {6'b0, pp[2], 2'b0} + {5'b0, pp[3], 3'b0};
        stage2_sum45 <= {4'b0, pp[4], 4'b0} + {3'b0, pp[5], 5'b0};
        stage2_sum67 <= {2'b0, pp[6], 6'b0} + {1'b0, pp[7], 7'b0};
    end
end

// Second adder stage pipeline
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage3_sum0123 <= 16'b0;
        stage3_sum4567 <= 16'b0;
        stage3_en <= 1'b0;
    end else begin
        stage3_en <= stage2_en;
        stage3_sum0123 <= stage2_sum01 + stage2_sum23;
        stage3_sum4567 <= stage2_sum45 + stage2_sum67;
    end
end

// Final adder stage pipeline
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage4_sum <= 16'b0;
        stage4_en <= 1'b0;
    end else begin
        stage4_en <= stage3_en;
        stage4_sum <= stage3_sum0123 + stage3_sum4567;
    end
end

// Output stage
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out <= 16'b0;
        mul_en_out <= 1'b0;
    end else begin
        mul_en_out <= stage4_en;
        mul_out <= stage4_sum;
    end
end

endmodule