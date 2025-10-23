module multi_pipe_8bit (
    input           clk,
    input           rst_n,
    input           mul_en_in,
    input   [7:0]   mul_a,
    input   [7:0]   mul_b,
    output reg      mul_en_out,
    output reg [15:0] mul_out
);

    // Pipeline register to propagate mul_en_in through 4 stages
    reg [3:0] mul_en_pipe;

    // Registers to hold input operands, update only on mul_en_in asserted
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;

    // Partial products: 8 partial products of 16 bits each
    wire [15:0] partial_products [7:0];
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : GEN_PARTIAL_PRODUCTS
            assign partial_products[i] = mul_b_reg[i] ? (mul_a_reg << i) : 16'd0;
        end
    endgenerate

    // Pipeline registers for partial sums
    reg [15:0] sum0; // sum of partial_products[0..2]
    reg [15:0] sum1; // sum of partial_products[3..5]
    reg [15:0] sum2; // sum of partial_products[6..7]

    // Final stage register for product
    reg [15:0] mul_out_reg;

    // 1) Propagate mul_en_in through 4-stage shift register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_en_pipe <= 4'b0;
        else
            mul_en_pipe <= {mul_en_pipe[2:0], mul_en_in};
    end

    // 2) Sample inputs when mul_en_in is asserted
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_a_reg <= 8'd0;
            mul_b_reg <= 8'd0;
        end else if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end
    end

    // 3) Stage 1: sum partial_products[0..2], update only if mul_en_pipe[0] is high
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            sum0 <= 16'd0;
        else if (mul_en_pipe[0])
            sum0 <= partial_products[0] + partial_products[1] + partial_products[2];
        else
            sum0 <= 16'd0;
    end

    // 4) Stage 2: sum partial_products[3..5], update only if mul_en_pipe[1] is high
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            sum1 <= 16'd0;
        else if (mul_en_pipe[1])
            sum1 <= partial_products[3] + partial_products[4] + partial_products[5];
        else
            sum1 <= 16'd0;
    end

    // 5) Stage 3: sum partial_products[6..7], update only if mul_en_pipe[2] is high
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            sum2 <= 16'd0;
        else if (mul_en_pipe[2])
            sum2 <= partial_products[6] + partial_products[7];
        else
            sum2 <= 16'd0;
    end

    // 6) Stage 4: sum sum0 + sum1 + sum2 to produce final product, update if mul_en_pipe[3] high
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_out_reg <= 16'd0;
        else if (mul_en_pipe[3])
            mul_out_reg <= sum0 + sum1 + sum2;
        else
            mul_out_reg <= 16'd0;
    end

    // 7) Output enable derived from MSB of mul_en_pipe shift register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_en_out <= 1'b0;
        else
            mul_en_out <= mul_en_pipe[3];
    end

    // 8) Output mux: output mul_out_reg only when mul_en_out is high; else zero
    always @(*) begin
        if (mul_en_out)
            mul_out = mul_out_reg;
        else
            mul_out = 16'd0;
    end

endmodule