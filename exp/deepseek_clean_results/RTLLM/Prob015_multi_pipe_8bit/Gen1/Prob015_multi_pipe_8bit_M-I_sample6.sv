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
    reg [15:0] sum_reg2, carry_reg2;
    reg en_reg2;
    
    // Pipeline stage 3 registers
    reg [15:0] product_reg3;
    reg en_reg3;
    
    // Partial products generation
    wire [15:0] pp [7:0];
    
    // Generate all partial products (shifted appropriately)
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : pp_gen
            assign pp[i] = mul_b_reg1[i] ? ({8'b0, mul_a_reg1} << i) : 16'b0;
        end
    endgenerate
    
    // Wallace tree reduction (4 levels)
    wire [15:0] level1_sum [3:0];
    wire [15:0] level1_carry [3:0];
    wire [15:0] level2_sum [1:0];
    wire [15:0] level2_carry [1:0];
    wire [15:0] level3_sum, level3_carry;
    
    // First level of reduction (reduce 8 to 6)
    full_adder fa0 (pp[0], pp[1], pp[2], level1_sum[0], level1_carry[0]);
    full_adder fa1 (pp[3], pp[4], pp[5], level1_sum[1], level1_carry[1]);
    assign level1_sum[2] = pp[6];
    assign level1_sum[3] = pp[7];
    assign level1_carry[2] = 16'b0;
    assign level1_carry[3] = 16'b0;
    
    // Second level of reduction (reduce 6 to 4)
    full_adder fa2 (level1_sum[0], level1_carry[0], level1_sum[1], level2_sum[0], level2_carry[0]);
    full_adder fa3 (level1_carry[1], level1_sum[2], level1_sum[3], level2_sum[1], level2_carry[1]);
    
    // Third level of reduction (reduce 4 to 3)
    full_adder fa4 (level2_sum[0], level2_carry[0], level2_sum[1], level3_sum, level3_carry);
    
    // Pipeline control
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all pipeline registers
            mul_a_reg1 <= 8'b0;
            mul_b_reg1 <= 8'b0;
            en_reg1 <= 1'b0;
            
            sum_reg2 <= 16'b0;
            carry_reg2 <= 16'b0;
            en_reg2 <= 1'b0;
            
            product_reg3 <= 16'b0;
            en_reg3 <= 1'b0;
            
            mul_en_out <= 1'b0;
            mul_out <= 16'b0;
        end else begin
            // Stage 1: Input registration
            if (mul_en_in) begin
                mul_a_reg1 <= mul_a;
                mul_b_reg1 <= mul_b;
            end
            en_reg1 <= mul_en_in;
            
            // Stage 2: Partial product reduction
            sum_reg2 <= level3_sum;
            carry_reg2 <= {level3_carry[14:0], 1'b0}; // Shift carry left by 1
            en_reg2 <= en_reg1;
            
            // Stage 3: Final addition
            product_reg3 <= sum_reg2 + carry_reg2;
            en_reg3 <= en_reg2;
            
            // Output
            mul_en_out <= en_reg3;
            mul_out <= en_reg3 ? product_reg3 : 16'b0;
        end
    end

endmodule

// Full adder module for Wallace tree
module full_adder(
    input [15:0] a,
    input [15:0] b,
    input [15:0] c,
    output [15:0] sum,
    output [15:0] carry
);
    assign sum = a ^ b ^ c;
    assign carry = (a & b) | (a & c) | (b & c);
endmodule