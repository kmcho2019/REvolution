module multi_pipe_8bit (
    input wire clk,
    input wire rst_n,
    input wire mul_en_in,
    input wire [7:0] mul_a,
    input wire [7:0] mul_b,
    output wire mul_en_out,
    output wire [15:0] mul_out
);

    // Clock gating control
    wire clk_gated;
    assign clk_gated = clk & (mul_en_in | |en_pipeline);

    // Pipeline stage registers
    reg [7:0] a_reg, b_reg;
    reg [15:0] pp0_reg, pp1_reg, pp2_reg, pp3_reg;
    reg [15:0] sum_low_reg, sum_high_reg;
    reg [15:0] result_reg;
    reg [3:0] en_pipeline;

    // Booth encoded partial products
    wire [16:0] pp [7:0];
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : booth_pp
            wire [1:0] sel = {b_reg[i], (i > 0) ? b_reg[i-1] : 1'b0};
            wire [8:0] pp_val;
            
            case (sel)
                2'b01: pp_val = {1'b0, a_reg};
                2'b10: pp_val = ~{1'b0, a_reg} + 1'b1;
                default: pp_val = 9'b0;
            endcase
            
            assign pp[i] = $signed(pp_val) << i;
        end
    endgenerate

    // Carry-save addition stages
    wire [15:0] csa_stage1_sum, csa_stage1_carry;
    wire [15:0] csa_stage2_sum, csa_stage2_carry;

    // First CSA stage (4:2 compressor)
    assign {csa_stage1_carry, csa_stage1_sum} = 
        pp[0] + pp[1] + pp[2] + pp[3];
    
    // Second CSA stage (4:2 compressor)
    assign {csa_stage2_carry, csa_stage2_sum} = 
        pp[4] + pp[5] + pp[6] + pp[7];

    // Final adder input
    wire [15:0] final_adder_a = sum_low_reg;
    wire [15:0] final_adder_b = sum_high_reg;
    wire [15:0] final_sum = final_adder_a + final_adder_b;

    // Pipeline control
    always @(posedge clk_gated or negedge rst_n) begin
        if (!rst_n) begin
            a_reg <= 8'b0;
            b_reg <= 8'b0;
            pp0_reg <= 16'b0;
            pp1_reg <= 16'b0;
            pp2_reg <= 16'b0;
            pp3_reg <= 16'b0;
            sum_low_reg <= 16'b0;
            sum_high_reg <= 16'b0;
            result_reg <= 16'b0;
            en_pipeline <= 4'b0;
        end else begin
            // Stage 1: Register inputs and first partial products
            a_reg <= mul_a;
            b_reg <= mul_b;
            pp0_reg <= pp[0][15:0];
            pp1_reg <= pp[1][15:0];
            
            // Stage 2: Register remaining partial products
            pp2_reg <= pp[2][15:0];
            pp3_reg <= pp[3][15:0];
            
            // Stage 3: Register CSA results
            sum_low_reg <= csa_stage1_sum + (csa_stage1_carry << 1);
            sum_high_reg <= csa_stage2_sum + (csa_stage2_carry << 1);
            
            // Stage 4: Final result
            result_reg <= final_sum;
            
            // Enable signal pipeline
            en_pipeline <= {en_pipeline[2:0], mul_en_in};
        end
    end

    // Output assignments
    assign mul_en_out = en_pipeline[3];
    assign mul_out = en_pipeline[3] ? result_reg : 16'b0;

endmodule