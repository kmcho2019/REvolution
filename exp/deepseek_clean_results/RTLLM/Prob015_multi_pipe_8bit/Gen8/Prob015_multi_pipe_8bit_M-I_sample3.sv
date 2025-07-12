module multi_pipe_8bit (
    input wire clk,
    input wire rst_n,
    input wire mul_en_in,
    input wire [7:0] mul_a,
    input wire [7:0] mul_b,
    output reg mul_en_out,
    output reg [15:0] mul_out
);

    // Clock gating signal
    wire clk_gated = clk & (mul_en_in | |en_reg1 | |en_reg2 | |en_reg3);
    
    // Pipeline stage 1 registers
    reg [7:0] mul_a_reg1, mul_b_reg1;
    reg en_reg1;
    
    // Pipeline stage 2 registers (partial products)
    reg [15:0] pp01_reg2, pp23_reg2, pp45_reg2, pp67_reg2;
    reg en_reg2;
    
    // Pipeline stage 3 registers (first level sums)
    reg [15:0] sum_low_reg3, sum_high_reg3;
    reg en_reg3;
    
    // Pipeline stage 4 registers (final sum)
    reg [15:0] final_sum_reg4;
    reg en_reg4;
    
    // Partial products generation with operand isolation
    wire [15:0] pp [7:0];
    generate
        for (genvar i = 0; i < 8; i = i + 1) begin : pp_gen
            assign pp[i] = (mul_en_in & mul_b_reg1[i]) ? ({8'b0, mul_a_reg1} << i) : 16'b0;
        end
    endgenerate
    
    // Stage 1: First level sums (combinational)
    wire [15:0] sum01 = pp[0] + pp[1];
    wire [15:0] sum23 = pp[2] + pp[3];
    wire [15:0] sum45 = pp[4] + pp[5];
    wire [15:0] sum67 = pp[6] + pp[7];
    
    // Stage 2: Second level sums (combinational)
    wire [15:0] sum_low = pp01_reg2 + pp23_reg2;
    wire [15:0] sum_high = pp45_reg2 + pp67_reg2;
    
    // Stage 3: Final sum (combinational)
    wire [15:0] final_sum = sum_low_reg3 + sum_high_reg3;
    
    // Pipeline control - sequential logic with clock gating
    always @(posedge clk_gated or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            mul_a_reg1 <= 8'b0;
            mul_b_reg1 <= 8'b0;
            pp01_reg2 <= 16'b0;
            pp23_reg2 <= 16'b0;
            pp45_reg2 <= 16'b0;
            pp67_reg2 <= 16'b0;
            sum_low_reg3 <= 16'b0;
            sum_high_reg3 <= 16'b0;
            final_sum_reg4 <= 16'b0;
            
            // Enable shift register
            en_reg1 <= 1'b0;
            en_reg2 <= 1'b0;
            en_reg3 <= 1'b0;
            en_reg4 <= 1'b0;
        end else begin
            // Stage 1: Input registration
            mul_a_reg1 <= mul_a;
            mul_b_reg1 <= mul_b;
            en_reg1 <= mul_en_in;
            
            // Stage 2: Partial product sums registration
            pp01_reg2 <= sum01;
            pp23_reg2 <= sum23;
            pp45_reg2 <= sum45;
            pp67_reg2 <= sum67;
            en_reg2 <= en_reg1;
            
            // Stage 3: Intermediate sums registration
            sum_low_reg3 <= sum_low;
            sum_high_reg3 <= sum_high;
            en_reg3 <= en_reg2;
            
            // Stage 4: Final result registration
            final_sum_reg4 <= final_sum;
            en_reg4 <= en_reg3;
        end
    end
    
    // Output assignment with reduced switching
    always @(*) begin
        mul_en_out = en_reg4;
        mul_out = final_sum_reg4;  // No need for mux when using operand isolation
    end

endmodule