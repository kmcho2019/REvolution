module multi_pipe_4bit #(parameter size = 4) (
    input                   clk,
    input                   rst_n,
    input      [size-1:0]   mul_a,
    input      [size-1:0]   mul_b,
    output reg [2*size-1:0] mul_out
);

    // Extend multiplicand by 'size' zero bits at MSB side
    wire [2*size-1:0] ext_mul_a = {{size{1'b0}}, mul_a};

    // Generate partial products combinationally
    // partial_product_i = mul_b[i] ? (ext_mul_a << i) : 0
    wire [2*size-1:0] partial_product_0 = mul_b[0] ? (ext_mul_a << 0) : {2*size{1'b0}};
    wire [2*size-1:0] partial_product_1 = mul_b[1] ? (ext_mul_a << 1) : {2*size{1'b0}};
    wire [2*size-1:0] partial_product_2 = mul_b[2] ? (ext_mul_a << 2) : {2*size{1'b0}};
    wire [2*size-1:0] partial_product_3 = mul_b[3] ? (ext_mul_a << 3) : {2*size{1'b0}};

    // Stage 1 registers: latch partial products and inputs (no reg arrays, use generate)
    // Individual registers for each partial product
    reg [2*size-1:0] stage1_partial_product_0;
    reg [2*size-1:0] stage1_partial_product_1;
    reg [2*size-1:0] stage1_partial_product_2;
    reg [2*size-1:0] stage1_partial_product_3;

    // Register extended multiplicand and multiplier bits for synchronization
    reg [2*size-1:0] stage1_ext_mul_a;
    reg [size-1:0]   stage1_mul_b;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage1_partial_product_0 <= 0;
            stage1_partial_product_1 <= 0;
            stage1_partial_product_2 <= 0;
            stage1_partial_product_3 <= 0;
            stage1_ext_mul_a <= 0;
            stage1_mul_b <= 0;
        end else begin
            stage1_partial_product_0 <= partial_product_0;
            stage1_partial_product_1 <= partial_product_1;
            stage1_partial_product_2 <= partial_product_2;
            stage1_partial_product_3 <= partial_product_3;
            stage1_ext_mul_a <= ext_mul_a;
            stage1_mul_b <= mul_b;
        end
    end

    // Stage 2 pipeline registers: sum partial products in two steps for better timing
    // Partial sums stage
    reg [2*size-1:0] stage2_sum_low;   // sum of partial_product_0 + partial_product_1
    reg [2*size-1:0] stage2_sum_high;  // sum of partial_product_2 + partial_product_3

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage2_sum_low <= 0;
            stage2_sum_high <= 0;
        end else begin
            stage2_sum_low <= stage1_partial_product_0 + stage1_partial_product_1;
            stage2_sum_high <= stage1_partial_product_2 + stage1_partial_product_3;
        end
    end

    // Final pipeline register to sum stage2 partial sums and output result
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out <= 0;
        end else begin
            mul_out <= stage2_sum_low + stage2_sum_high;
        end
    end

endmodule