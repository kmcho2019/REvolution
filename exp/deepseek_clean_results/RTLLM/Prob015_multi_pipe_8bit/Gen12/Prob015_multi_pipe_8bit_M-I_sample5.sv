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
    
    // Pipeline stage 2 registers (partial products as array)
    reg [15:0] pp_reg2 [3:0];
    reg en_reg2;
    
    // Pipeline stage 3 registers (intermediate sums)
    reg [15:0] sum_reg3 [1:0];
    reg en_reg3;
    
    // Pipeline stage 4 register (final result)
    reg [15:0] final_reg4;
    reg en_reg4;
    
    // Stage 1: Generate partial products with operand isolation
    wire [15:0] pp [3:0];
    assign pp[0] = mul_b_reg1[0] ? shifted_a[0] : 16'b0;
    assign pp[1] = mul_b_reg1[1] ? shifted_a[1] : 16'b0;
    assign pp[2] = mul_b_reg1[2] ? shifted_a[2] : 16'b0;
    assign pp[3] = mul_b_reg1[3] ? shifted_a[3] : 16'b0;
    
    wire [15:0] pp_hi [3:0];
    assign pp_hi[0] = mul_b_reg1[4] ? shifted_a[4] : 16'b0;
    assign pp_hi[1] = mul_b_reg1[5] ? shifted_a[5] : 16'b0;
    assign pp_hi[2] = mul_b_reg1[6] ? shifted_a[6] : 16'b0;
    assign pp_hi[3] = mul_b_reg1[7] ? shifted_a[7] : 16'b0;
    
    // Stage 2: First level sums
    wire [15:0] sum01 = pp[0] + pp[1];
    wire [15:0] sum23 = pp[2] + pp[3];
    wire [15:0] sum45 = pp_hi[0] + pp_hi[1];
    wire [15:0] sum67 = pp_hi[2] + pp_hi[3];
    
    // Stage 3: Second level sums
    wire [15:0] sum_low = sum_reg3[0];
    wire [15:0] sum_high = sum_reg3[1];
    
    // Pipeline control
    always @(posedge clk_gated or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            mul_a_reg1 <= 8'b0;
            mul_b_reg1 <= 8'b0;
            for (int i = 0; i < 4; i = i + 1) pp_reg2[i] <= 16'b0;
            for (int i = 0; i < 2; i = i + 1) sum_reg3[i] <= 16'b0;
            final_reg4 <= 16'b0;
            
            // Reset enable signals
            en_reg1 <= 1'b0;
            en_reg2 <= 1'b0;
            en_reg3 <= 1'b0;
            en_reg4 <= 1'b0;
        end else begin
            // Stage 1: Input registration
            mul_a_reg1 <= mul_a;
            mul_b_reg1 <= mul_b;
            en_reg1 <= mul_en_in;
            
            // Stage 2: Register partial sums
            pp_reg2[0] <= sum01;
            pp_reg2[1] <= sum23;
            pp_reg2[2] <= sum45;
            pp_reg2[3] <= sum67;
            en_reg2 <= en_reg1;
            
            // Stage 3: Register intermediate sums
            sum_reg3[0] <= pp_reg2[0] + pp_reg2[1];
            sum_reg3[1] <= pp_reg2[2] + pp_reg2[3];
            en_reg3 <= en_reg2;
            
            // Stage 4: Final result
            final_reg4 <= sum_low + sum_high;
            en_reg4 <= en_reg3;
        end
    end
    
    // Registered outputs for power optimization
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_out <= 1'b0;
            mul_out <= 16'b0;
        end else begin
            mul_en_out <= en_reg4;
            mul_out <= final_reg4;
        end
    end

endmodule