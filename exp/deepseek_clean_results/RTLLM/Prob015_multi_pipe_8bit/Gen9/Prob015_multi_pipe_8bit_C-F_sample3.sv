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
    
    // Pipeline stage 2 registers (partial sums)
    reg [15:0] sum_low_reg2, sum_high_reg2;
    reg en_reg2;
    
    // Pipeline stage 3 registers (final sum)
    reg [15:0] final_sum_reg3;
    reg en_reg3;
    
    // Clock gating signal (simplified)
    wire clk_gated = clk & (mul_en_in | en_reg1 | en_reg2);
    
    // Partial products generation with efficient operand isolation
    wire [15:0] pp [7:0];
    generate
        for (genvar i = 0; i < 8; i = i + 1) begin : pp_gen
            assign pp[i] = mul_b_reg1[i] ? ({8'b0, mul_a_reg1} << i) : 16'b0;
        end
    endgenerate
    
    // Stage 1: First level sums (combinational)
    wire [15:0] sum_low = pp[0] + pp[1] + pp[2] + pp[3];
    wire [15:0] sum_high = pp[4] + pp[5] + pp[6] + pp[7];
    
    // Stage 2: Final sum (combinational)
    wire [15:0] final_sum = sum_low_reg2 + sum_high_reg2;
    
    // Pipeline control - sequential logic with clock gating
    always @(posedge clk_gated or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            mul_a_reg1 <= 8'b0;
            mul_b_reg1 <= 8'b0;
            sum_low_reg2 <= 16'b0;
            sum_high_reg2 <= 16'b0;
            final_sum_reg3 <= 16'b0;
            
            // Enable shift register
            en_reg1 <= 1'b0;
            en_reg2 <= 1'b0;
            en_reg3 <= 1'b0;
        end else begin
            // Stage 1: Input registration
            if (mul_en_in) begin
                mul_a_reg1 <= mul_a;
                mul_b_reg1 <= mul_b;
            end
            en_reg1 <= mul_en_in;
            
            // Stage 2: Intermediate sums registration
            sum_low_reg2 <= sum_low;
            sum_high_reg2 <= sum_high;
            en_reg2 <= en_reg1;
            
            // Stage 3: Final result registration
            final_sum_reg3 <= final_sum;
            en_reg3 <= en_reg2;
        end
    end
    
    // Output assignment with operand isolation
    always @(*) begin
        mul_en_out = en_reg3;
        mul_out = en_reg3 ? final_sum_reg3 : 16'b0;
    end

endmodule