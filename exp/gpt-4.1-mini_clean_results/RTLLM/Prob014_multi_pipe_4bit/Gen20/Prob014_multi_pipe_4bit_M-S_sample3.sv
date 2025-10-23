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

    // Generate partial products combinationally for each bit of mul_b
    wire [product_width-1:0] partial_products [0:size-1];
    genvar i;
    generate
        for (i = 0; i < size; i = i + 1) begin : PARTIAL_PROD_GEN
            assign partial_products[i] = mul_b[i] ? (mul_a_ext << i) : {product_width{1'b0}};
        end
    endgenerate

    // Stage 1 registers: latch partial products
    reg [product_width-1:0] stage1_pp [0:size-1];

    integer j;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (j = 0; j < size; j = j + 1) begin
                stage1_pp[j] <= {product_width{1'b0}};
            end
        end else begin
            for (j = 0; j < size; j = j + 1) begin
                stage1_pp[j] <= partial_products[j];
            end
        end
    end

    // Stage 2 register: sum of partial products
    reg [product_width-1:0] stage2_sum;

    // Combinational sum of all stage1 partial products
    wire [product_width-1:0] pp_sum;
    assign pp_sum = stage1_pp[0] + stage1_pp[1] + stage1_pp[2] + stage1_pp[3];

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage2_sum <= {product_width{1'b0}};
            mul_out <= {product_width{1'b0}};
        end else begin
            stage2_sum <= pp_sum;
            mul_out <= stage2_sum;
        end
    end

endmodule