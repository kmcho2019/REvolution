module multi_pipe_4bit (
    input clk,  // clock signal
    input rst_n,  // active-low reset signal
    input [3:0] mul_a,  // input signal representing the multiplicand
    input [3:0] mul_b,  // input signal representing the multiplier
    output reg [7:0] mul_out  // product output signal
);

parameter size = 4;

// Generate partial products using a loop
wire [7:0] partial_product [3:0];
genvar i;
generate
    for (i = 0; i < size; i++) begin
        assign partial_product[i] = (mul_b[i] == 1'b1) ? ({4'b0, mul_a} << i) : 8'd0;
    end
endgenerate

// Pipeline registers
reg [7:0] stage1_reg;
reg [7:0] stage2_reg;

// Pipeline accumulation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage1_reg <= 8'd0;
        stage2_reg <= 8'd0;
        mul_out <= 8'd0;
    end else begin
        // Stage 1: Accumulate partial products from mul_b[0] and mul_b[1]
        stage1_reg <= partial_product[0] + partial_product[1];
        
        // Stage 2: Accumulate stage1_reg with partial products from mul_b[2] and mul_b[3]
        stage2_reg <= stage1_reg + partial_product[2] + partial_product[3];
        
        // Final output
        mul_out <= stage2_reg;
    end
end

endmodule