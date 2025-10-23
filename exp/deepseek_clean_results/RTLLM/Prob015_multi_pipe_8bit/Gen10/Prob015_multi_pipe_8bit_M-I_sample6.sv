module multi_pipe_8bit (
    input wire clk,
    input wire rst_n,
    input wire mul_en_in,
    input wire [7:0] mul_a,
    input wire [7:0] mul_b,
    output wire mul_en_out,
    output wire [15:0] mul_out
);

    // Clock gating logic
    wire gated_clk;
    assign gated_clk = clk & (mul_en_in | stage1_en | stage2_en);

    // Pipeline stage 1: Input registration
    reg [7:0] stage1_a, stage1_b;
    reg stage1_en;
    
    // Pipeline stage 2: Partial products with carry-save adders
    reg [15:0] stage2_sum, stage2_carry;
    reg stage2_en;
    
    // Pipeline stage 3: Final result
    reg [15:0] stage3_result;
    reg stage3_en;
    
    // Generate partial products more efficiently
    wire [15:0] pp [0:7];
    generate
        genvar i;
        for (i = 0; i < 8; i = i + 1) begin : pp_gen
            assign pp[i] = stage1_b[i] ? ({8'b0, stage1_a} << i) : 16'b0;
        end
    endgenerate
    
    // Carry-save addition for partial products
    wire [15:0] sum01, carry01, sum23, carry23;
    wire [15:0] sum45, carry45, sum67, carry67;
    
    // First level CSA
    assign {carry01, sum01} = pp[0] + pp[1];
    assign {carry23, sum23} = pp[2] + pp[3];
    assign {carry45, sum45} = pp[4] + pp[5];
    assign {carry67, sum67} = pp[6] + pp[7];
    
    // Second level CSA
    wire [15:0] sum0123, carry0123;
    wire [15:0] sum4567, carry4567;
    assign {carry0123, sum0123} = sum01 + sum23 + {carry01[14:0], 1'b0} + {carry23[14:0], 1'b0};
    assign {carry4567, sum4567} = sum45 + sum67 + {carry45[14:0], 1'b0} + {carry67[14:0], 1'b0};
    
    // Final result calculation
    wire [15:0] final_sum = stage2_sum + stage2_carry;
    
    // Pipeline register updates
    always @(posedge gated_clk or negedge rst_n) begin
        if (!rst_n) begin
            // Clear only necessary registers
            stage1_a <= 8'b0;
            stage1_b <= 8'b0;
            stage1_en <= 1'b0;
            
            stage2_sum <= 16'b0;
            stage2_carry <= 16'b0;
            stage2_en <= 1'b0;
            
            stage3_result <= 16'b0;
            stage3_en <= 1'b0;
        end else begin
            // Stage 1: Register inputs
            stage1_a <= mul_a;
            stage1_b <= mul_b;
            stage1_en <= mul_en_in;
            
            // Stage 2: Register carry-save sums
            stage2_sum <= sum0123 + sum4567;
            stage2_carry <= {carry0123[14:0], 1'b0} + {carry4567[14:0], 1'b0};
            stage2_en <= stage1_en;
            
            // Stage 3: Register final result
            stage3_result <= final_sum;
            stage3_en <= stage2_en;
        end
    end
    
    // Output assignments
    assign mul_en_out = stage3_en;
    assign mul_out = stage3_en ? stage3_result : 16'b0;

endmodule