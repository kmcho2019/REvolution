module multi_pipe_8bit (
    input              clk,
    input              rst_n,
    input              mul_en_in,
    input      [7:0]   mul_a,
    input      [7:0]   mul_b,
    output reg         mul_en_out,
    output reg [15:0]  mul_out
);

    // Registers for inputs and enable signal
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;
    reg       mul_en_reg;

    // Partial products wires
    wire [15:0] partial_products [7:0];
    integer i;

    // Register inputs and enable
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_reg <= 1'b0;
            mul_a_reg <= 8'd0;
            mul_b_reg <= 8'd0;
        end else begin
            mul_en_reg <= mul_en_in;
            if (mul_en_in) begin
                mul_a_reg <= mul_a;
                mul_b_reg <= mul_b;
            end
        end
    end

    // Generate partial products by shifting multiplicand and masking by multiplier bits
    generate
        genvar idx;
        for (idx = 0; idx < 8; idx = idx + 1) begin : gen_partial_products
            assign partial_products[idx] = mul_b_reg[idx] ? (mul_a_reg << idx) : 16'd0;
        end
    endgenerate

    // Combinational sum of partial products
    wire [15:0] sum_partial;
    assign sum_partial = partial_products[0] + partial_products[1] + partial_products[2] +
                         partial_products[3] + partial_products[4] + partial_products[5] +
                         partial_products[6] + partial_products[7];

    // Register output enable and product
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_out <= 1'b0;
            mul_out <= 16'd0;
        end else begin
            mul_en_out <= mul_en_reg;
            mul_out <= mul_en_reg ? sum_partial : 16'd0;
        end
    end

endmodule