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
    reg [7:0] mul_a_reg, mul_b_reg;
    reg en_reg;
    
    // Pipeline stage 2 registers (carry-save format)
    reg [15:0] sum0_reg, sum1_reg;
    reg [15:0] carry_reg;
    reg en_reg2;
    
    // Pipeline stage 3 registers
    reg [15:0] final_sum_reg;
    reg en_reg3;
    
    // Partial products (operand isolated)
    wire [15:0] pp [7:0];
    wire en_gated = en_reg & mul_en_in;
    
    // Generate all partial products with operand isolation
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : pp_gen
            assign pp[i] = en_gated ? (mul_b_reg[i] ? ({8'b0, mul_a_reg} << i) : 16'b0) : 16'b0;
        end
    endgenerate
    
    // First level addition (4+4 in carry-save format)
    wire [15:0] sum0 = pp[0] + pp[1] + pp[2];
    wire [15:0] sum1 = pp[3] + pp[4] + pp[5];
    wire [15:0] carry = (pp[0] & pp[1]) | (pp[0] & pp[2]) | (pp[1] & pp[2]) |
                       (pp[3] & pp[4]) | (pp[3] & pp[5]) | (pp[4] & pp[5]);
    
    // Second level addition
    wire [15:0] pp6_ext = {8'b0, pp[6][7:0]};
    wire [15:0] pp7_ext = {8'b0, pp[7][7:0]};
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            mul_a_reg <= 8'b0;
            mul_b_reg <= 8'b0;
            en_reg <= 1'b0;
            sum0_reg <= 16'b0;
            sum1_reg <= 16'b0;
            carry_reg <= 16'b0;
            en_reg2 <= 1'b0;
            final_sum_reg <= 16'b0;
            en_reg3 <= 1'b0;
            mul_en_out <= 1'b0;
            mul_out <= 16'b0;
        end else begin
            // Stage 1: Input registration
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
            en_reg <= mul_en_in;
            
            // Stage 2: Partial sums in carry-save format
            sum0_reg <= sum0;
            sum1_reg <= sum1;
            carry_reg <= carry;
            en_reg2 <= en_reg;
            
            // Stage 3: Final addition
            final_sum_reg <= sum0_reg + sum1_reg + carry_reg + pp6_ext + pp7_ext;
            en_reg3 <= en_reg2;
            
            // Output
            mul_en_out <= en_reg3;
            mul_out <= final_sum_reg;
        end
    end

endmodule