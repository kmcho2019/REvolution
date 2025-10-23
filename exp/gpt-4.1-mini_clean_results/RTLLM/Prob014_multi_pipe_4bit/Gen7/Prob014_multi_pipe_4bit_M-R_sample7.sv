module multi_pipe_4bit #(
    parameter size = 4,
    localparam product_width = 2 * size
)(
    input                         clk,
    input                         rst_n,    // Active low reset
    input      [size-1:0]         mul_a,
    input      [size-1:0]         mul_b,
    output reg [product_width-1:0] mul_out
);

    // Extend multiplicand to product width by zero-padding MSBs
    wire [product_width-1:0] mul_a_ext = { {(product_width-size){1'b0}}, mul_a };

    // Generate combinational partial products array for each multiplier bit
    wire [product_width-1:0] partial_products [0:size-1];

    genvar i;
    generate
        for (i = 0; i < size; i = i + 1) begin : gen_partial_products
            assign partial_products[i] = mul_b[i] ? (mul_a_ext << i) : {product_width{1'b0}};
        end
    endgenerate

    // Stage 1 pipeline registers: sum partial products bits [1:0] and bits [3:2]
    reg [product_width-1:0] stage1_sum_low;
    reg [product_width-1:0] stage1_sum_high;

    // Stage 2 pipeline register: sum of stage1 sums
    reg [product_width-1:0] stage2_sum;

    // Pipeline Stage 1: sum partial products bits 0 and 1, and bits 2 and 3
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage1_sum_low  <= {product_width{1'b0}};
            stage1_sum_high <= {product_width{1'b0}};
        end else begin
            stage1_sum_low  <= partial_products[0] + partial_products[1];
            stage1_sum_high <= partial_products[2] + partial_products[3];
        end
    end

    // Pipeline Stage 2: sum stage1 results and update output
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage2_sum <= {product_width{1'b0}};
            mul_out    <= {product_width{1'b0}};
        end else begin
            stage2_sum <= stage1_sum_low + stage1_sum_high;
            mul_out    <= stage2_sum;
        end
    end

endmodule