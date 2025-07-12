module multi_pipe_8bit (
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output reg mul_en_out,
    output reg [15:0] mul_out
);

// Pipeline stage registers
reg [3:0] en_pipe;  // Enable signal pipeline
reg [7:0] a_reg, b_reg;
reg [15:0] pp [0:7];  // Registered partial products
reg [15:0] sum_stage1 [0:3];  // First level sums
reg [15:0] sum_stage2 [0:1];  // Second level sums
reg [15:0] final_sum;         // Final sum

// Generate partial products (gated with enable)
wire [15:0] pp_gen [0:7];
genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin : pp_gen
        assign pp_gen[i] = en_pipe[0] ? (b_reg[i] ? ({8'b0, a_reg} << i) : 16'b0) : 16'b0;
    end
endgenerate

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all pipeline registers
        en_pipe <= 4'b0;
        a_reg <= 8'b0;
        b_reg <= 8'b0;
        
        for (integer j = 0; j < 8; j = j + 1)
            pp[j] <= 16'b0;
            
        sum_stage1[0] <= 16'b0;
        sum_stage1[1] <= 16'b0;
        sum_stage1[2] <= 16'b0;
        sum_stage1[3] <= 16'b0;
        
        sum_stage2[0] <= 16'b0;
        sum_stage2[1] <= 16'b0;
        
        final_sum <= 16'b0;
        mul_out <= 16'b0;
    end
    else begin
        // Pipeline stage 0: Input sampling
        en_pipe[0] <= mul_en_in;
        if (mul_en_in) begin
            a_reg <= mul_a;
            b_reg <= mul_b;
        end

        // Pipeline stage 1: Partial product registration
        en_pipe[1] <= en_pipe[0];
        for (integer j = 0; j < 8; j = j + 1)
            pp[j] <= pp_gen[j];

        // Pipeline stage 2: First level additions (balanced tree)
        en_pipe[2] <= en_pipe[1];
        sum_stage1[0] <= pp[0] + pp[1];
        sum_stage1[1] <= pp[2] + pp[3];
        sum_stage1[2] <= pp[4] + pp[5];
        sum_stage1[3] <= pp[6] + pp[7];

        // Pipeline stage 3: Second level additions
        en_pipe[3] <= en_pipe[2];
        sum_stage2[0] <= sum_stage1[0] + sum_stage1[1];
        sum_stage2[1] <= sum_stage1[2] + sum_stage1[3];

        // Pipeline stage 4: Final addition and output
        mul_en_out <= en_pipe[3];
        final_sum <= sum_stage2[0] + sum_stage2[1];
        mul_out <= final_sum;
    end
end

endmodule