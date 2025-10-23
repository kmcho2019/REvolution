module multi_pipe_4bit #(
    parameter size = 4,
    parameter product_width = 2 * size
)(
    input                    clk,
    input                    rst_n,    // active low reset
    input      [size-1:0]    mul_a,
    input      [size-1:0]    mul_b,
    output reg [product_width-1:0] mul_out
);

    // Stage 0: Register inputs to synchronize pipeline
    reg [size-1:0] mul_a_reg, mul_b_reg;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_a_reg <= 0;
            mul_b_reg <= 0;
        end else begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end
    end

    // Extend multiplicand with zeros on MSB side
    wire [product_width-1:0] mul_a_ext = {{size{1'b0}}, mul_a_reg};

    // Stage 1: Generate partial products combinationally based on registered mul_b and mul_a
    wire [product_width-1:0] partial_products [0:size-1];
    genvar i;
    generate
        for (i = 0; i < size; i = i + 1) begin : gen_partial_products
            assign partial_products[i] = mul_b_reg[i] ? (mul_a_ext << i) : {product_width{1'b0}};
        end
    endgenerate

    // Register partial products (Stage 1 pipeline registers)
    reg [product_width-1:0] pp_reg [0:size-1];
    integer j;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (j = 0; j < size; j = j + 1)
                pp_reg[j] <= 0;
        end else begin
            for (j = 0; j < size; j = j + 1)
                pp_reg[j] <= partial_products[j];
        end
    end

    // Stage 2: Add partial products in pairs and register the sums
    // sum0 = pp_reg[0] + pp_reg[1], sum1 = pp_reg[2] + pp_reg[3]
    reg [product_width-1:0] sum0_reg, sum1_reg;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum0_reg <= 0;
            sum1_reg <= 0;
        end else begin
            sum0_reg <= pp_reg[0] + pp_reg[1];
            sum1_reg <= pp_reg[2] + pp_reg[3];
        end
    end

    // Stage 3: Add the two sums and register the final product output
    reg [product_width-1:0] final_sum_reg;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            final_sum_reg <= 0;
            mul_out <= 0;
        end else begin
            final_sum_reg <= sum0_reg + sum1_reg;
            mul_out <= final_sum_reg;
        end
    end

endmodule