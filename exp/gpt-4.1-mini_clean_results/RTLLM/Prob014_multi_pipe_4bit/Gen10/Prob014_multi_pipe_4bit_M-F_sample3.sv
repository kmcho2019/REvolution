module multi_pipe_4bit #(parameter size = 4) (
    input                   clk,
    input                   rst_n,
    input      [size-1:0]   mul_a,
    input      [size-1:0]   mul_b,
    output reg [2*size-1:0] mul_out
);

    // Extend multiplicand by 'size' zero bits on MSB side
    wire [2*size-1:0] ext_mul_a = {{size{1'b0}}, mul_a};

    integer i;

    // --- Stage 1 registers ---
    // Register inputs
    reg [2*size-1:0] stage1_mul_a;
    reg [size-1:0]   stage1_mul_b;

    // Partial products for bits 0 and 1, plus their sum
    reg [2*size-1:0] stage1_partial_products_0;
    reg [2*size-1:0] stage1_partial_products_1;
    reg [2*size-1:0] stage1_sum;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage1_mul_a            <= 0;
            stage1_mul_b            <= 0;
            stage1_partial_products_0 <= 0;
            stage1_partial_products_1 <= 0;
            stage1_sum              <= 0;
        end else begin
            // Register extended multiplicand and multiplier
            stage1_mul_a <= ext_mul_a;
            stage1_mul_b <= mul_b;

            // Generate partial products for bit 0 and 1 and register
            stage1_partial_products_0 <= stage1_mul_b[0] ? (ext_mul_a << 0) : 0;
            stage1_partial_products_1 <= stage1_mul_b[1] ? (ext_mul_a << 1) : 0;

            // Sum partial products bits 0 and 1 and register
            stage1_sum <= (stage1_mul_b[0] ? (ext_mul_a << 0) : 0) + 
                          (stage1_mul_b[1] ? (ext_mul_a << 1) : 0);
        end
    end

    // --- Stage 2 registers ---
    // Partial products for bits 2 and 3
    reg [2*size-1:0] partial_products_2;
    reg [2*size-1:0] partial_products_3;

    // Sum of partial products bits 2 and 3
    reg [2*size-1:0] sum_23;

    // Register final output
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            partial_products_2 <= 0;
            partial_products_3 <= 0;
            sum_23             <= 0;
            mul_out            <= 0;
        end else begin
            // Generate partial products for bits 2 and 3 based on registered multiplier from stage 1
            partial_products_2 <= stage1_mul_b[2] ? (stage1_mul_a << 2) : 0;
            partial_products_3 <= stage1_mul_b[3] ? (stage1_mul_a << 3) : 0;

            // Sum partial products bits 2 and 3
            sum_23 <= partial_products_2 + partial_products_3;

            // Final product = sum of stage1 sum + sum of bits 2 & 3 partial products
            mul_out <= stage1_sum + (partial_products_2 + partial_products_3);
        end
    end

endmodule