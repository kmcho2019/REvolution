module multi_pipe_8bit (
    input wire clk,
    input wire rst_n,
    input wire mul_en_in,
    input wire [7:0] mul_a,
    input wire [7:0] mul_b,
    output reg mul_en_out,
    output reg [15:0] mul_out
);

    // Simplified clock gating
    wire clk_gated = clk & mul_en_in;
    
    // Pipeline stage 1 registers
    reg [7:0] mul_a_reg1, mul_b_reg1;
    reg en_reg1;
    
    // Precomputed shifted versions of multiplicand
    wire [15:0] shifted_a [7:0];
    generate
        for (genvar i = 0; i < 8; i = i + 1) begin : shift_gen
            assign shifted_a[i] = {8'b0, mul_a_reg1} << i;
        end
    endgenerate
    
    // Pipeline stage 2 registers (partial products)
    reg [15:0] pp_sum_reg2 [3:0];  // Consolidated register array
    reg en_reg2;
    
    // Pipeline stage 3 registers (intermediate sums)
    reg [15:0] sum_reg3 [1:0];     // Consolidated register array
    reg en_reg3;
    
    // Pipeline stage 4 registers (final result)
    reg [15:0] final_sum_reg4;
    reg en_reg4;
    
    // Partial products with operand isolation
    wire [15:0] pp [7:0];
    generate
        for (genvar i = 0; i < 8; i = i + 1) begin : pp_gen
            assign pp[i] = mul_b_reg1[i] ? shifted_a[i] : 16'b0;
        end
    endgenerate
    
    // Stage 1: First level sums (combinational)
    wire [15:0] sum01 = pp[0] + pp[1];
    wire [15:0] sum23 = pp[2] + pp[3];
    wire [15:0] sum45 = pp[4] + pp[5];
    wire [15:0] sum67 = pp[6] + pp[7];
    
    // Stage 2: Second level sums (combinational)
    wire [15:0] sum_low = pp_sum_reg2[0] + pp_sum_reg2[1];
    wire [15:0] sum_high = pp_sum_reg2[2] + pp_sum_reg2[3];
    
    // Pipeline control - sequential logic with simplified clock gating
    always @(posedge clk_gated or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            mul_a_reg1 <= 8'b0;
            mul_b_reg1 <= 8'b0;
            for (int i = 0; i < 4; i = i + 1) pp_sum_reg2[i] <= 16'b0;
            for (int i = 0; i < 2; i = i + 1) sum_reg3[i] <= 16'b0;
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
            pp_sum_reg2[0] <= sum01;
            pp_sum_reg2[1] <= sum23;
            pp_sum_reg2[2] <= sum45;
            pp_sum_reg2[3] <= sum67;
            en_reg2 <= en_reg1;
            
            // Stage 3: Intermediate sums registration
            sum_reg3[0] <= sum_low;
            sum_reg3[1] <= sum_high;
            en_reg3 <= en_reg2;
            
            // Stage 4: Final result registration
            final_sum_reg4 <= sum_reg3[0] + sum_reg3[1];
            en_reg4 <= en_reg3;
        end
    end
    
    // Gated output assignment
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out <= 16'b0;
            mul_en_out <= 1'b0;
        end else if (en_reg4) begin
            mul_out <= final_sum_reg4;
            mul_en_out <= 1'b1;
        end else begin
            mul_out <= 16'b0;
            mul_en_out <= 1'b0;
        end
    end

endmodule