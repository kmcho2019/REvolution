module multi_pipe_8bit (
    input wire clk,
    input wire rst_n,
    input wire mul_en_in,
    input wire [7:0] mul_a,
    input wire [7:0] mul_b,
    output reg mul_en_out,
    output reg [15:0] mul_out
);

    // Pipeline stage 1 registers
    reg [7:0] mul_a_reg1, mul_b_reg1;
    reg en_reg1;
    
    // Pipeline stage 2 registers
    reg [15:0] pp_sum_reg2, pp_carry_reg2;
    reg en_reg2;
    
    // Pipeline stage 3 registers
    reg [15:0] final_sum_reg3;
    reg en_reg3;
    
    // Internal signals for partial products
    wire [7:0] pp [7:0];
    wire [15:0] pp_ext [7:0];
    wire [15:0] sum_stage1, carry_stage1;
    wire [15:0] sum_stage2, carry_stage2;
    wire [15:0] final_sum;
    
    // Generate partial products
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : pp_gen
            assign pp[i] = mul_b_reg1[i] ? mul_a_reg1 : 8'b0;
            assign pp_ext[i] = {8'b0, pp[i]} << i;
        end
    endgenerate
    
    // First stage of reduction (4:2 compressor)
    assign sum_stage1 = pp_ext[0] ^ pp_ext[1] ^ pp_ext[2] ^ pp_ext[3];
    assign carry_stage1 = ((pp_ext[0] & pp_ext[1]) | (pp_ext[0] & pp_ext[2]) | (pp_ext[1] & pp_ext[2])) ^ 
                         (pp_ext[3] & (pp_ext[0] ^ pp_ext[1] ^ pp_ext[2]));
    
    // Second stage of reduction (4:2 compressor)
    assign sum_stage2 = pp_ext[4] ^ pp_ext[5] ^ pp_ext[6] ^ pp_ext[7];
    assign carry_stage2 = ((pp_ext[4] & pp_ext[5]) | (pp_ext[4] & pp_ext[6]) | (pp_ext[5] & pp_ext[6])) ^ 
                         (pp_ext[7] & (pp_ext[4] ^ pp_ext[5] ^ pp_ext[6]));
    
    // Final addition
    assign final_sum = sum_stage1 + carry_stage1 + sum_stage2 + carry_stage2;
    
    // Pipeline control
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all pipeline registers
            mul_a_reg1 <= 8'b0;
            mul_b_reg1 <= 8'b0;
            en_reg1 <= 1'b0;
            
            pp_sum_reg2 <= 16'b0;
            pp_carry_reg2 <= 16'b0;
            en_reg2 <= 1'b0;
            
            final_sum_reg3 <= 16'b0;
            en_reg3 <= 1'b0;
            
            mul_en_out <= 1'b0;
            mul_out <= 16'b0;
        end else begin
            // Stage 1: Input registers
            if (mul_en_in) begin
                mul_a_reg1 <= mul_a;
                mul_b_reg1 <= mul_b;
            end
            en_reg1 <= mul_en_in;
            
            // Stage 2: Partial product reduction
            pp_sum_reg2 <= sum_stage1 + sum_stage2;
            pp_carry_reg2 <= carry_stage1 + carry_stage2;
            en_reg2 <= en_reg1;
            
            // Stage 3: Final addition
            final_sum_reg3 <= pp_sum_reg2 + pp_carry_reg2;
            en_reg3 <= en_reg2;
            
            // Output
            mul_en_out <= en_reg3;
            mul_out <= en_reg3 ? final_sum_reg3 : 16'b0;
        end
    end

endmodule