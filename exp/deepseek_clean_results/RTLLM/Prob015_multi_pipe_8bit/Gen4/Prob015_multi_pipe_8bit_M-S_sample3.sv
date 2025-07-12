module multi_pipe_8bit (
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output reg mul_en_out,
    output reg [15:0] mul_out
);

// Input registers
reg [7:0] mul_a_reg, mul_b_reg;
reg en_reg;

// Partial products
wire [15:0] partial_products [7:0];

// Generate partial products
genvar i;
generate
    for (i = 0; i < 8; i = i + 1) begin : pp_gen
        assign partial_products[i] = mul_b_reg[i] ? ({8'b0, mul_a_reg} << i) : 16'b0;
    end
endgenerate

// Sum all partial products
wire [15:0] product = partial_products[0] + partial_products[1] +
                     partial_products[2] + partial_products[3] +
                     partial_products[4] + partial_products[5] +
                     partial_products[6] + partial_products[7];

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all registers
        mul_a_reg <= 8'b0;
        mul_b_reg <= 8'b0;
        en_reg <= 1'b0;
        mul_out <= 16'b0;
        mul_en_out <= 1'b0;
    end else begin
        // Register inputs and enable
        en_reg <= mul_en_in;
        if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end

        // Register output only when valid
        mul_en_out <= en_reg;
        if (en_reg) begin
            mul_out <= product;
        end else begin
            mul_out <= 16'b0;
        end
    end
end

endmodule