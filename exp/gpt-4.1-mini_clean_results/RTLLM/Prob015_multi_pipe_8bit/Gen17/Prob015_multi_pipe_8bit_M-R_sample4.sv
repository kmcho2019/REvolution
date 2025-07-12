module multi_pipe_8bit (
    input           clk,
    input           rst_n,
    input           mul_en_in,
    input   [7:0]   mul_a,
    input   [7:0]   mul_b,
    output          mul_en_out,
    output  [15:0]  mul_out
);

    // Enable pipeline registers to track valid data at each pipeline stage
    reg mul_en_stg0, mul_en_stg1, mul_en_stg2, mul_en_stg3;

    // Input registers sampled on mul_en_in asserted
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;

    // Partial products combinational wires
    wire [15:0] partial_products [7:0];

    genvar i;
    generate
        for(i = 0; i < 8; i = i + 1) begin : gen_partial_products
            assign partial_products[i] = mul_b_reg[i] ? (mul_a_reg << i) : 16'd0;
        end
    endgenerate

    // Pipeline registers for partial sums
    reg [15:0] sum0_reg; // stage 1 sum of partial_products[0..2]
    reg [15:0] sum1_reg; // stage 2 sum of partial_products[3..5]
    reg [15:0] sum2_reg; // stage 3 sum of partial_products[6..7]
    reg [15:0] product_reg; // final product register

    // Input sampling and enable pipeline stage 0
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_stg0 <= 1'b0;
            mul_a_reg <= 8'd0;
            mul_b_reg <= 8'd0;
        end else begin
            mul_en_stg0 <= mul_en_in;
            if (mul_en_in) begin
                mul_a_reg <= mul_a;
                mul_b_reg <= mul_b;
            end
        end
    end

    // Enable pipeline stages 1 to 3
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_en_stg1 <= 1'b0;
            mul_en_stg2 <= 1'b0;
            mul_en_stg3 <= 1'b0;
        end else begin
            mul_en_stg1 <= mul_en_stg0;
            mul_en_stg2 <= mul_en_stg1;
            mul_en_stg3 <= mul_en_stg2;
        end
    end

    // Stage 1: sum partial_products[0..2]
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            sum0_reg <= 16'd0;
        else if (mul_en_stg0)
            sum0_reg <= partial_products[0] + partial_products[1] + partial_products[2];
        else
            sum0_reg <= 16'd0;
    end

    // Stage 2: sum partial_products[3..5]
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            sum1_reg <= 16'd0;
        else if (mul_en_stg1)
            sum1_reg <= partial_products[3] + partial_products[4] + partial_products[5];
        else
            sum1_reg <= 16'd0;
    end

    // Stage 3: sum partial_products[6..7]
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            sum2_reg <= 16'd0;
        else if (mul_en_stg2)
            sum2_reg <= partial_products[6] + partial_products[7];
        else
            sum2_reg <= 16'd0;
    end

    // Final stage: sum all sums to get product
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            product_reg <= 16'd0;
        else if (mul_en_stg3)
            product_reg <= sum0_reg + sum1_reg + sum2_reg;
        else
            product_reg <= 16'd0;
    end

    // Output enable directly driven from last pipeline enable register
    assign mul_en_out = mul_en_stg3;

    // Output product valid only when mul_en_out is asserted, else zero
    assign mul_out = mul_en_out ? product_reg : 16'd0;

endmodule