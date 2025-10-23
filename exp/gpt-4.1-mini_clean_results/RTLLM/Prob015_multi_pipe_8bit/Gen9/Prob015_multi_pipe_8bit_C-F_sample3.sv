module multi_pipe_8bit (
    input           clk,
    input           rst_n,
    input           mul_en_in,
    input   [7:0]   mul_a,
    input   [7:0]   mul_b,
    output          mul_en_out,
    output  [15:0]  mul_out
);

    // 4-stage enable pipeline to track valid data through pipeline
    reg [3:0] mul_en_pipe;

    // Input registers: sample inputs when mul_en_in is asserted
    reg [7:0] mul_a_reg;
    reg [7:0] mul_b_reg;

    // Partial products wires - 8 partial products
    wire [15:0] partial_products [7:0];
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : gen_partial_products
            assign partial_products[i] = mul_b_reg[i] ? (mul_a_reg << i) : 16'b0;
        end
    endgenerate

    // Stage 1 partial sum registers - sum groups of 4 partial products
    reg [15:0] sum_group0; // Sum partial_products[0..3]
    reg [15:0] sum_group1; // Sum partial_products[4..7]

    // Stage 2 final product register
    reg [15:0] mul_out_reg;

    // Enable pipeline shift register update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_en_pipe <= 4'b0;
        else
            mul_en_pipe <= {mul_en_pipe[2:0], mul_en_in};
    end

    // Input registers update on mul_en_in active
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_a_reg <= 8'b0;
            mul_b_reg <= 8'b0;
        end else if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end
    end

    // Stage 1: sum first 4 partial products, register when mul_en_pipe[1] is high
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            sum_group0 <= 16'b0;
        else if (mul_en_pipe[1])
            sum_group0 <= partial_products[0] + partial_products[1] + partial_products[2] + partial_products[3];
        else
            sum_group0 <= 16'b0;
    end

    // Stage 1: sum last 4 partial products, register when mul_en_pipe[1] is high
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            sum_group1 <= 16'b0;
        else if (mul_en_pipe[1])
            sum_group1 <= partial_products[4] + partial_products[5] + partial_products[6] + partial_products[7];
        else
            sum_group1 <= 16'b0;
    end

    // Stage 2: sum the two groups to get final product, register when mul_en_pipe[2] is high
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_out_reg <= 16'b0;
        else if (mul_en_pipe[2])
            mul_out_reg <= sum_group0 + sum_group1;
        else
            mul_out_reg <= 16'b0;
    end

    // Output enable signal from MSB of enable pipeline
    assign mul_en_out = mul_en_pipe[3];

    // Output product is valid only when mul_en_out is high, else zero
    assign mul_out = mul_en_out ? mul_out_reg : 16'b0;

endmodule