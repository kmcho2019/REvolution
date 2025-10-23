module multi_pipe_8bit (
    input wire clk,
    input wire rst_n,
    input wire mul_en_in,
    input wire [7:0] mul_a,
    input wire [7:0] mul_b,
    output reg mul_en_out,
    output reg [15:0] mul_out
);

    // Pipeline stage 1 registers (Input)
    reg [7:0] a_reg, b_reg;
    reg en_reg1;
    
    // Pipeline stage 2 registers (Partial Products)
    reg [15:0] sum1_reg, sum2_reg;
    reg en_reg2;
    
    // Pipeline stage 3 registers (Final Sum)
    reg [15:0] result_reg;
    reg en_reg3;
    
    // Generate all partial products
    wire [15:0] pp [7:0];
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : pp_gen
            assign pp[i] = b_reg[i] ? ({8'b0, a_reg} << i) : 16'b0;
        end
    endgenerate
    
    // Intermediate sums (first 4 and last 4 partial products)
    wire [15:0] sum1 = pp[0] + pp[1] + pp[2] + pp[3];
    wire [15:0] sum2 = pp[4] + pp[5] + pp[6] + pp[7];
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all pipeline registers
            a_reg <= 8'b0;
            b_reg <= 8'b0;
            en_reg1 <= 1'b0;
            
            sum1_reg <= 16'b0;
            sum2_reg <= 16'b0;
            en_reg2 <= 1'b0;
            
            result_reg <= 16'b0;
            en_reg3 <= 1'b0;
            
            mul_en_out <= 1'b0;
            mul_out <= 16'b0;
        end else begin
            // Stage 1: Input registration
            a_reg <= mul_a;
            b_reg <= mul_b;
            en_reg1 <= mul_en_in;
            
            // Stage 2: Partial product sums
            sum1_reg <= sum1;
            sum2_reg <= sum2;
            en_reg2 <= en_reg1;
            
            // Stage 3: Final addition
            result_reg <= sum1_reg + sum2_reg;
            en_reg3 <= en_reg2;
            
            // Output
            mul_en_out <= en_reg3;
            mul_out <= en_reg3 ? result_reg : 16'b0;
        end
    end

endmodule