module multi_pipe_8bit (
    input wire clk,
    input wire rst_n,
    input wire mul_en_in,
    input wire [7:0] mul_a,
    input wire [7:0] mul_b,
    output reg mul_en_out,
    output reg [15:0] mul_out
);

    // Input registers
    reg [7:0] mul_a_reg, mul_b_reg;
    reg en_reg;
    
    // Partial products
    wire [15:0] pp [7:0];
    
    // Generate all partial products
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : pp_gen
            assign pp[i] = mul_b_reg[i] ? ({8'b0, mul_a_reg} << i) : 16'b0;
        end
    endgenerate
    
    // Final sum
    wire [15:0] final_sum = pp[0] + pp[1] + pp[2] + pp[3] + 
                           pp[4] + pp[5] + pp[6] + pp[7];
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            mul_a_reg <= 8'b0;
            mul_b_reg <= 8'b0;
            en_reg <= 1'b0;
            mul_en_out <= 1'b0;
            mul_out <= 16'b0;
        end else begin
            // Register inputs
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
            en_reg <= mul_en_in;
            
            // Register outputs
            mul_en_out <= en_reg;
            mul_out <= final_sum;
        end
    end

endmodule