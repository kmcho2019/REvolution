module multi_pipe_4bit #(
    parameter size = 4,
    parameter product_width = 2 * size
)(
    input                       clk,
    input                       rst_n,      // Active low reset
    input       [size-1:0]      mul_a,
    input       [size-1:0]      mul_b,
    output reg  [product_width-1:0] mul_out
);

    // Extend multiplicand by adding size zeros at MSB side
    wire [product_width-1:0] mul_a_ext = {{size{1'b0}}, mul_a};

    // Generate partial products using a generate block
    wire [product_width-1:0] partial_products [size-1:0];
    genvar i;
    generate
        for (i = 0; i < size; i = i + 1) begin : gen_pp
            assign partial_products[i] = mul_b[i] ? (mul_a_ext << i) : {product_width{1'b0}};
        end
    endgenerate

    // Stage 1 registers: latch all partial products
    reg [product_width-1:0] stage1_pp [size-1:0];

    // Stage 2 register: sum of all partial products
    reg [product_width-1:0] stage2_sum;

    integer idx;

    // Stage 1: latch partial products
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (idx = 0; idx < size; idx = idx + 1) begin
                stage1_pp[idx] <= {product_width{1'b0}};
            end
        end else begin
            for (idx = 0; idx < size; idx = idx + 1) begin
                stage1_pp[idx] <= partial_products[idx];
            end
        end
    end

    // Stage 2: sum partial products and register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage2_sum <= {product_width{1'b0}};
        end else begin
            // sum all stage1 partial products
            stage2_sum <= stage1_pp[0] + stage1_pp[1] + stage1_pp[2] + stage1_pp[3];
        end
    end

    // Output: drive from stage2_sum
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out <= {product_width{1'b0}};
        end else begin
            mul_out <= stage2_sum;
        end
    end

endmodule