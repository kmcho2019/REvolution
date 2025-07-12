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
    wire clk_en = mul_en_in | en_reg1 | en_reg2;
    wire clk_gated = clk & clk_en;

    // Pipeline stage 1: Input registration
    reg [7:0] a_reg, b_reg;
    reg en_reg1;
    
    // Pipeline stage 2: Partial products and first-level sums
    reg [15:0] sum0_reg, sum1_reg;
    reg en_reg2;
    
    // Pipeline stage 3: Final accumulation
    reg [15:0] result_reg;
    reg en_reg3;
    
    // Pre-shifted versions of multiplicand
    wire [15:0] a_shifted [7:0];
    generate
        for (genvar i = 0; i < 8; i = i + 1) begin : shift_gen
            assign a_shifted[i] = {8'b0, a_reg} << i;
        end
    endgenerate
    
    // Partial products with operand isolation
    wire [15:0] pp [7:0];
    generate
        for (genvar i = 0; i < 8; i = i + 1) begin : pp_gen
            assign pp[i] = (en_reg1 & b_reg[i]) ? a_shifted[i] : 16'b0;
        end
    endgenerate
    
    // Balanced adder tree
    wire [15:0] sum0 = pp[0] + pp[1] + pp[2] + pp[3];
    wire [15:0] sum1 = pp[4] + pp[5] + pp[6] + pp[7];
    wire [15:0] final_sum = sum0_reg + sum1_reg;
    
    // Pipeline control
    always @(posedge clk_gated or negedge rst_n) begin
        if (!rst_n) begin
            a_reg <= 8'b0;
            b_reg <= 8'b0;
            sum0_reg <= 16'b0;
            sum1_reg <= 16'b0;
            result_reg <= 16'b0;
            en_reg1 <= 1'b0;
            en_reg2 <= 1'b0;
            en_reg3 <= 1'b0;
        end else begin
            // Stage 1: Input registration
            a_reg <= mul_a;
            b_reg <= mul_b;
            en_reg1 <= mul_en_in;
            
            // Stage 2: First-level sums
            sum0_reg <= sum0;
            sum1_reg <= sum1;
            en_reg2 <= en_reg1;
            
            // Stage 3: Final result
            result_reg <= final_sum;
            en_reg3 <= en_reg2;
        end
    end
    
    // Output assignments
    assign mul_en_out = en_reg3;
    assign mul_out = en_reg3 ? result_reg : 16'b0;

endmodule