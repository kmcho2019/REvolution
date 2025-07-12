module multi_pipe_8bit (
    input wire clk,
    input wire rst_n,
    input wire mul_en_in,
    input wire [7:0] mul_a,
    input wire [7:0] mul_b,
    output reg mul_en_out,
    output reg [15:0] mul_out
);

    // Pipeline stage 1 registers (Input and Partial Products)
    reg [7:0] a_reg, b_reg;
    reg en_reg1;
    
    // Pipeline stage 2 registers (Final Sum)
    reg [15:0] result_reg;
    reg en_reg2;
    
    // Generate all partial products
    wire [15:0] pp [7:0];
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : pp_gen
            assign pp[i] = b_reg[i] ? ({8'b0, a_reg} << i) : 16'b0;
        end
    endgenerate
    
    // Sum all partial products in one step
    wire [15:0] sum = pp[0] + pp[1] + pp[2] + pp[3] + 
                      pp[4] + pp[5] + pp[6] + pp[7];
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all pipeline registers
            a_reg <= 8'b0;
            b_reg <= 8'b0;
            en_reg1 <= 1'b0;
            
            result_reg <= 16'b0;
            en_reg2 <= 1'b0;
            
            mul_en_out <= 1'b0;
            mul_out <= 16'b0;
        end else begin
            // Stage 1: Input registration and partial product generation
            a_reg <= mul_a;
            b_reg <= mul_b;
            en_reg1 <= mul_en_in;
            
            // Stage 2: Final sum and output
            result_reg <= sum;
            en_reg2 <= en_reg1;
            
            // Output
            mul_en_out <= en_reg2;
            mul_out <= en_reg2 ? result_reg : 16'b0;
        end
    end

endmodule