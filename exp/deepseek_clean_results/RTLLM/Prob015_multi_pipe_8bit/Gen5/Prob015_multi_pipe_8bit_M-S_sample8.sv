module multi_pipe_8bit (
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output reg mul_en_out,
    output reg [15:0] mul_out
);

// Pipeline registers
reg [7:0] mul_a_reg, mul_b_reg;
reg en_reg;
reg [15:0] product_reg;

// Partial products
wire [15:0] partial_products [7:0];

// Generate partial products
genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin : pp_gen
        assign partial_products[i] = mul_b_reg[i] ? ({8'b0, mul_a_reg} << i) : 16'b0;
    end
endgenerate

// Adder tree
wire [15:0] sum = ((partial_products[0] + partial_products[1]) + 
                   (partial_products[2] + partial_products[3])) +
                  ((partial_products[4] + partial_products[5]) + 
                   (partial_products[6] + partial_products[7]));

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all registers
        mul_a_reg <= 8'b0;
        mul_b_reg <= 8'b0;
        en_reg <= 1'b0;
        product_reg <= 16'b0;
        mul_out <= 16'b0;
        mul_en_out <= 1'b0;
    end else begin
        // Pipeline stage 1: Register inputs
        en_reg <= mul_en_in;
        if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end

        // Pipeline stage 2: Calculate and register product
        product_reg <= sum;
        
        // Output assignment
        mul_out <= en_reg ? product_reg : 16'b0;
        mul_en_out <= en_reg;
    end
end

endmodule