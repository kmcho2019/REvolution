module multi_pipe_8bit (
    input wire clk,
    input wire rst_n,
    input wire mul_en_in,
    input wire [7:0] mul_a,
    input wire [7:0] mul_b,
    output wire mul_en_out,
    output wire [15:0] mul_out
);

    // Simplified clock gating
    wire clk_gated = clk & mul_en_in;
    
    // Shift register for enable signals (4 stages)
    reg [3:0] en_shift_reg;
    
    // Pipeline registers
    reg [7:0] mul_a_reg, mul_b_reg;
    reg [15:0] pp_sum [1:0];  // Combined partial product sums
    reg [15:0] final_sum_reg;
    
    // Partial products with operand isolation
    wire [15:0] pp [7:0];
    assign pp[0] = mul_b_reg[0] ? {8'b0, mul_a_reg} : 16'b0;
    assign pp[1] = mul_b_reg[1] ? {7'b0, mul_a_reg, 1'b0} : 16'b0;
    assign pp[2] = mul_b_reg[2] ? {6'b0, mul_a_reg, 2'b0} : 16'b0;
    assign pp[3] = mul_b_reg[3] ? {5'b0, mul_a_reg, 3'b0} : 16'b0;
    assign pp[4] = mul_b_reg[4] ? {4'b0, mul_a_reg, 4'b0} : 16'b0;
    assign pp[5] = mul_b_reg[5] ? {3'b0, mul_a_reg, 5'b0} : 16'b0;
    assign pp[6] = mul_b_reg[6] ? {2'b0, mul_a_reg, 6'b0} : 16'b0;
    assign pp[7] = mul_b_reg[7] ? {1'b0, mul_a_reg, 7'b0} : 16'b0;
    
    // Adder tree stages
    wire [15:0] sum_stage1 [3:0];
    assign sum_stage1[0] = pp[0] + pp[1];
    assign sum_stage1[1] = pp[2] + pp[3];
    assign sum_stage1[2] = pp[4] + pp[5];
    assign sum_stage1[3] = pp[6] + pp[7];
    
    wire [15:0] sum_stage2 [1:0];
    assign sum_stage2[0] = sum_stage1[0] + sum_stage1[1];
    assign sum_stage2[1] = sum_stage1[2] + sum_stage1[3];
    
    wire [15:0] sum_final = sum_stage2[0] + sum_stage2[1];
    
    // Pipeline control
    always @(posedge clk_gated or negedge rst_n) begin
        if (!rst_n) begin
            en_shift_reg <= 4'b0;
            mul_a_reg <= 8'b0;
            mul_b_reg <= 8'b0;
            pp_sum[0] <= 16'b0;
            pp_sum[1] <= 16'b0;
            final_sum_reg <= 16'b0;
        end else begin
            // Shift enable through pipeline
            en_shift_reg <= {en_shift_reg[2:0], mul_en_in};
            
            // Stage 1: Input registration
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
            
            // Stage 2: First level sums
            pp_sum[0] <= sum_stage2[0];
            pp_sum[1] <= sum_stage2[1];
            
            // Stage 3: Final sum
            final_sum_reg <= sum_final;
        end
    end
    
    // Output assignments
    assign mul_en_out = en_shift_reg[3];
    assign mul_out = en_shift_reg[3] ? final_sum_reg : 16'b0;

endmodule