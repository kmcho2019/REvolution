module multi_pipe_4bit #(
    parameter size = 4,
    parameter product_width = 2 * size
)(
    input                   clk,
    input                   rst_n,       // active low reset
    input  [size-1:0]       mul_a,
    input  [size-1:0]       mul_b,
    output reg [product_width-1:0] mul_out
);

    // Extend multiplicand by adding 'size' zeros on MSB side
    wire [product_width-1:0] mul_a_ext = {{size{1'b0}}, mul_a};

    // Generate partial products combinationally using generate block
    wire [product_width-1:0] partial_products [0:size-1];

    genvar i;
    generate
        for (i = 0; i < size; i = i + 1) begin : gen_partial_products
            assign partial_products[i] = mul_b[i] ? (mul_a_ext << i) : {product_width{1'b0}};
        end
    endgenerate

    // First pipeline stage registers: store partial products to align timing
    reg [product_width-1:0] stage1_pp [0:size-1];

    integer j;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (j = 0; j < size; j = j + 1)
                stage1_pp[j] <= {product_width{1'b0}};
        end else begin
            for (j = 0; j < size; j = j + 1)
                stage1_pp[j] <= partial_products[j];
        end
    end

    // Second pipeline stage register: sum partial products from stage1 registers
    reg [product_width-1:0] stage2_sum;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage2_sum <= {product_width{1'b0}};
            mul_out <= {product_width{1'b0}};
        end else begin
            // Sum all registered partial products at stage 1 and store in stage 2 register
            stage2_sum <= stage1_pp[0] + stage1_pp[1] + stage1_pp[2] + stage1_pp[3];
            // Output register updated with stage2_sum from previous cycle
            mul_out <= stage2_sum;
        end
    end

endmodule