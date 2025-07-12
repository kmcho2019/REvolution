module multi_pipe_8bit (
    input wire clk,
    input wire rst_n,
    input wire mul_en_in,
    input wire [7:0] mul_a,
    input wire [7:0] mul_b,
    output wire mul_en_out,
    output wire [15:0] mul_out
);

    // Pipeline stage registers with clock gating
    reg [7:0] a_reg, b_reg;
    reg [15:0] pp_reg [0:3];  // Merged partial product registers
    reg [15:0] result_reg;
    reg [1:0] en_pipeline;    // Reduced to match pipeline depth
    
    // Clock gating control
    wire pipeline_en = mul_en_in | (|en_pipeline);
    wire clk_gated = clk & pipeline_en;

    // Partial product generation with operand isolation
    wire [7:0] a_active = pipeline_en ? a_reg : 8'b0;
    wire [7:0] b_active = pipeline_en ? b_reg : 8'b0;
    
    function [15:0] gen_pp;
        input [7:0] a;
        input [7:0] b;
        input [2:0] shift;
        gen_pp = { (8-shift)'(0), (b[shift] ? a : 8'b0), shift'(0) };
    endfunction

    // Partial products (parameterized shifts)
    wire [15:0] pp [0:7];
    generate
        for (genvar i = 0; i < 8; i = i + 1) begin : pp_gen
            assign pp[i] = gen_pp(a_active, b_active, i[2:0]);
        end
    endgenerate

    // Balanced pipeline stages
    wire [15:0] stage1_sum0 = pp[0] + pp[1];
    wire [15:0] stage1_sum1 = pp[2] + pp[3];
    wire [15:0] stage2_sum0 = pp[4] + pp[5];
    wire [15:0] stage2_sum1 = pp[6] + pp[7];
    
    wire [15:0] stage3_sum0 = pp_reg[0] + pp_reg[1];
    wire [15:0] stage3_sum1 = pp_reg[2] + pp_reg[3];
    
    wire [15:0] final_sum = stage3_sum0 + stage3_sum1;

    // Pipeline control (using gated clock)
    always @(posedge clk_gated or negedge rst_n) begin
        if (!rst_n) begin
            a_reg <= 8'b0;
            b_reg <= 8'b0;
            pp_reg[0] <= 16'b0;
            pp_reg[1] <= 16'b0;
            pp_reg[2] <= 16'b0;
            pp_reg[3] <= 16'b0;
            result_reg <= 16'b0;
            en_pipeline <= 2'b0;
        end else begin
            // Stage 1: Register inputs and first partial sums
            a_reg <= mul_a;
            b_reg <= mul_b;
            pp_reg[0] <= stage1_sum0;
            pp_reg[1] <= stage1_sum1;
            
            // Stage 2: Register second partial sums
            pp_reg[2] <= stage2_sum0;
            pp_reg[3] <= stage2_sum1;
            
            // Stage 3: Register intermediate sums
            pp_reg[0] <= stage3_sum0;
            pp_reg[1] <= stage3_sum1;
            
            // Stage 4: Register final result
            result_reg <= final_sum;
            
            // Enable signal pipeline (matches 4-stage pipeline)
            en_pipeline <= {en_pipeline[0], mul_en_in};
        end
    end

    // Output assignments
    assign mul_en_out = en_pipeline[1];
    assign mul_out = en_pipeline[1] ? result_reg : 16'b0;

endmodule