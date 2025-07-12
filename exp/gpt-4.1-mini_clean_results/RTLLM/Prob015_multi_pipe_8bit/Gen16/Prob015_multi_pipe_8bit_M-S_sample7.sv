module multi_pipe_8bit (
    input              clk,
    input              rst_n,
    input              mul_en_in,
    input      [7:0]   mul_a,
    input      [7:0]   mul_b,
    output reg         mul_en_out,
    output reg [15:0]  mul_out
);

    // Stage 1 registers: inputs and enable
    reg        mul_en_reg;
    reg [7:0]  mul_a_reg;
    reg [7:0]  mul_b_reg;

    // Stage 2 registers: final product and enable
    reg        mul_en_reg2;
    reg [15:0] mul_out_reg;

    // Partial products wires
    wire [15:0] partial_products [7:0];
    integer i;

    // Register inputs and enable (stage 1)
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

    // Generate partial products by shifting multiplicand per multiplier bit
    generate
        genvar idx;
        for (idx = 0; idx < 8; idx = idx + 1) begin : gen_partial_products
            assign partial_products[idx] = mul_b_reg[idx] ? (mul_a_reg << idx) : 16'd0;
        end
    endgenerate

    // Sum partial products combinationally
    wire [15:0] partial_sum;
    assign partial_sum = partial_products[0] + partial_products[1] + partial_products[2] +
                         partial_products[3] + partial_products[4] + partial_products[5] +
                         partial_products[6] + partial_products[7];

    // Register output product and enable (stage 2)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_reg2 <= 1'b0;
            mul_out_reg <= 16'd0;
        end else begin
            mul_en_reg2 <= mul_en_reg;
            mul_out_reg <= mul_en_reg ? partial_sum : 16'd0;
        end
    end

    // Output assignments
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_out <= 1'b0;
            mul_out <= 16'd0;
        end else begin
            mul_en_out <= mul_en_reg2;
            mul_out <= mul_en_reg2 ? mul_out_reg : 16'd0;
        end
    end

endmodule