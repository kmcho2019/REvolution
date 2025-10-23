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
    reg [15:0] sum_low_reg2, sum_high_reg2;
    reg en_reg2;
    
    // Pipeline stage 3 registers
    reg [15:0] final_sum_reg3;
    reg en_reg3;
    
    // Generate gated partial products
    wire [15:0] pp [7:0];
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : pp_gen
            assign pp[i] = mul_b_reg1[i] ? ({8'b0, mul_a_reg1} << i) : 16'b0;
        end
    endgenerate
    
    // Balanced adder tree stage 1
    wire [15:0] sum_low = pp[0] + pp[1] + pp[2] + pp[3];
    wire [15:0] sum_high = pp[4] + pp[5] + pp[6] + pp[7];
    
    // Final sum calculation
    wire [15:0] final_sum = sum_low_reg2 + sum_high_reg2;
    
    // Pipeline control
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Only reset essential registers
            mul_a_reg1 <= 8'b0;
            mul_b_reg1 <= 8'b0;
            en_reg1 <= 1'b0;
            en_reg2 <= 1'b0;
            en_reg3 <= 1'b0;
            mul_en_out <= 1'b0;
            mul_out <= 16'b0;
        end else begin
            // Stage 1: Input registration
            mul_a_reg1 <= mul_a;
            mul_b_reg1 <= mul_b;
            en_reg1 <= mul_en_in;
            
            // Stage 2: First level of adder tree
            sum_low_reg2 <= sum_low;
            sum_high_reg2 <= sum_high;
            en_reg2 <= en_reg1;
            
            // Stage 3: Final addition
            final_sum_reg3 <= final_sum;
            en_reg3 <= en_reg2;
            
            // Output with early gating
            mul_en_out <= en_reg3;
            mul_out <= en_reg3 ? final_sum_reg3 : 16'b0;
        end
    end

endmodule