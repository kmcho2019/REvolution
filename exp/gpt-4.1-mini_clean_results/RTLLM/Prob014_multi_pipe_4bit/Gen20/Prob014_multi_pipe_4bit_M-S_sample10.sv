module multi_pipe_4bit #(
    parameter size = 4,
    parameter product_width = 2 * size
)(
    input                     clk,
    input                     rst_n,      // active low reset
    input      [size-1:0]     mul_a,
    input      [size-1:0]     mul_b,
    output reg [product_width-1:0] mul_out
);

    // Extend multiplicand by adding size zeros at MSB side
    wire [product_width-1:0] mul_a_ext = { {size{1'b0}}, mul_a };

    // Partial products array
    wire [product_width-1:0] partial_products [size-1:0];

    genvar i;
    generate
        for (i = 0; i < size; i = i + 1) begin : gen_partial_products
            assign partial_products[i] = mul_b[i] ? (mul_a_ext << i) : {product_width{1'b0}};
        end
    endgenerate

    // Stage 1 registers: latch partial products
    reg [product_width-1:0] stage1_pp [size-1:0];

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

    // Stage 2 register: sum all partial products from stage 1
    reg [product_width-1:0] stage2_sum;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage2_sum <= {product_width{1'b0}};
        end else begin
            // Sum all partial products registered in stage1_pp
            stage2_sum <= stage1_pp[0] + stage1_pp[1] + stage1_pp[2] + stage1_pp[3];
        end
    end

    // Output register: hold final product (stage2_sum)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out <= {product_width{1'b0}};
        end else begin
            mul_out <= stage2_sum;
        end
    end

endmodule