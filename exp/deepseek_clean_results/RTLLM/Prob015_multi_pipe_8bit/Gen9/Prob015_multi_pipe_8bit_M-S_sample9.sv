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
            
            // Calculate product in one cycle
            mul_out <= mul_a_reg * mul_b_reg;
            
            // Propagate enable signal
            mul_en_out <= en_reg;
        end
    end

endmodule