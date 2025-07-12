module multi_pipe_8bit (
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output reg mul_en_out,
    output reg [15:0] mul_out
);

// Input stage registers
reg [7:0] stage1_a, stage1_b;
reg stage1_en;

// Partial product generation wires
wire [15:0] pp [7:0];

// Intermediate sum registers
reg [15:0] stage2_sum_low, stage2_sum_high;
reg stage2_en;

// Enable pipeline as shift register
wire [2:0] en_pipeline_next = {en_pipeline[1:0], mul_en_in};
reg [2:0] en_pipeline;

// Generate all partial products
genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin : pp_gen
        assign pp[i] = stage1_b[i] ? ({8'b0, stage1_a} << i) : 16'b0;
    end
endgenerate

// Combinational sum of partial products
wire [15:0] sum_low = pp[0] + pp[1] + pp[2] + pp[3];
wire [15:0] sum_high = pp[4] + pp[5] + pp[6] + pp[7];

// Continuous assignment for enable pipeline
assign en_pipeline_next = {en_pipeline[1:0], mul_en_in};

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all registers
        stage1_a <= 8'b0;
        stage1_b <= 8'b0;
        stage1_en <= 1'b0;
        stage2_sum_low <= 16'b0;
        stage2_sum_high <= 16'b0;
        stage2_en <= 1'b0;
        mul_out <= 16'b0;
        en_pipeline <= 3'b0;
        mul_en_out <= 1'b0;
    end else begin
        // Stage 1: Input sampling
        stage1_en <= mul_en_in;
        if (mul_en_in) begin
            stage1_a <= mul_a;
            stage1_b <= mul_b;
        end

        // Stage 2: Intermediate sums
        stage2_en <= stage1_en;
        if (stage1_en) begin
            stage2_sum_low <= sum_low;
            stage2_sum_high <= sum_high;
        end

        // Stage 3: Final output
        mul_out <= stage2_sum_low + stage2_sum_high;
        mul_en_out <= en_pipeline[2];
        
        // Enable pipeline
        en_pipeline <= en_pipeline_next;
    end
end

endmodule