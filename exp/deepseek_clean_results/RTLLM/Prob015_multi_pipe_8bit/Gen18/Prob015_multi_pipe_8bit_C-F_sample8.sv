module multi_pipe_8bit (
    input wire clk,
    input wire rst_n,
    input wire mul_en_in,
    input wire [7:0] mul_a,
    input wire [7:0] mul_b,
    output reg mul_en_out,
    output reg [15:0] mul_out
);

    // Pipeline stage 1 registers (input)
    reg [7:0] mul_a_reg, mul_b_reg;
    reg en_reg1;
    
    // Pipeline stage 2 registers (partial sums)
    reg [15:0] pp_reg [1:0];  // Reduced to 2 registers for balanced adder tree
    reg en_reg2;
    
    // Pipeline stage 3 registers (final sum)
    reg [15:0] final_sum_reg;
    reg en_reg3;
    
    // Partial products with operand isolation (generate block style)
    wire [15:0] pp [7:0];
    generate
        for (genvar i = 0; i < 8; i = i + 1) begin : pp_gen
            assign pp[i] = mul_b_reg[i] ? ({8'b0, mul_a_reg} << i) : 16'b0;
        end
    endgenerate
    
    // Balanced adder tree (carry-save style)
    wire [15:0] sum01 = pp[0] + pp[1];
    wire [15:0] sum23 = pp[2] + pp[3];
    wire [15:0] sum45 = pp[4] + pp[5];
    wire [15:0] sum67 = pp[6] + pp[7];
    
    // Intermediate sums
    wire [15:0] sum_low = sum01 + sum23;
    wire [15:0] sum_high = sum45 + sum67;
    
    // Final sum
    wire [15:0] final_sum = sum_low + sum_high;
    
    // Pipeline control
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            mul_a_reg <= 8'b0;
            mul_b_reg <= 8'b0;
            pp_reg[0] <= 16'b0;
            pp_reg[1] <= 16'b0;
            final_sum_reg <= 16'b0;
            
            // Enable shift register
            en_reg1 <= 1'b0;
            en_reg2 <= 1'b0;
            en_reg3 <= 1'b0;
        end else begin
            // Stage 1: Input registration
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
            en_reg1 <= mul_en_in;
            
            // Stage 2: Partial sums registration
            pp_reg[0] <= sum_low;
            pp_reg[1] <= sum_high;
            en_reg2 <= en_reg1;
            
            // Stage 3: Final result registration
            final_sum_reg <= pp_reg[0] + pp_reg[1];  // Final addition in last stage
            en_reg3 <= en_reg2;
        end
    end
    
    // Output assignment with conditional gating
    always @(*) begin
        mul_en_out = en_reg3;
        mul_out = en_reg3 ? final_sum_reg : 16'b0;
    end

endmodule