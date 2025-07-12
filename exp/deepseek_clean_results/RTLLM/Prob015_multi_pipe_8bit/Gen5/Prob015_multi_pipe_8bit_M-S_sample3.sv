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
    
    // Pipeline stage 2 registers
    reg [15:0] sum_reg;
    reg en_reg2;
    
    // Partial products
    wire [15:0] pp [7:0];
    
    // Generate all partial products
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : pp_gen
            assign pp[i] = mul_b_reg[i] ? ({8'b0, mul_a_reg} << i) : 16'b0;
        end
    endgenerate
    
    // First level addition (4+4)
    wire [15:0] sum0 = pp[0] + pp[1] + pp[2] + pp[3];
    wire [15:0] sum1 = pp[4] + pp[5] + pp[6] + pp[7];
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            mul_a_reg <= 8'b0;
            mul_b_reg <= 8'b0;
            en_reg <= 1'b0;
            sum_reg <= 16'b0;
            en_reg2 <= 1'b0;
            mul_en_out <= 1'b0;
            mul_out <= 16'b0;
        end else begin
            // Stage 1: Input registration and partial product generation
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
            en_reg <= mul_en_in;
            
            // Stage 2: Final addition
            sum_reg <= sum0 + sum1;
            en_reg2 <= en_reg;
            
            // Output
            mul_en_out <= en_reg2;
            mul_out <= sum_reg;
        end
    end

endmodule