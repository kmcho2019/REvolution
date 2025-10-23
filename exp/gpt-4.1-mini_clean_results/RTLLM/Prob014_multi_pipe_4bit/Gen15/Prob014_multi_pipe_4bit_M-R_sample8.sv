module multi_pipe_4bit #(
    parameter size = 4,
    parameter product_width = 2 * size
)(
    input                      clk,
    input                      rst_n,
    input      [size-1:0]      mul_a,
    input      [size-1:0]      mul_b,
    output reg [product_width-1:0] mul_out
);

    // Zero-extend multiplicand to product_width bits by padding size zeros at MSB
    wire [product_width-1:0] mul_a_ext = {{size{1'b0}}, mul_a};

    // Partial products combinational generation: mul_b[i] ? (mul_a_ext << i) : 0
    wire [product_width-1:0] partial_products [0:size-1];
    genvar i;
    generate
        for (i = 0; i < size; i = i + 1) begin : gen_partial_products
            assign partial_products[i] = mul_b[i] ? (mul_a_ext << i) : {product_width{1'b0}};
        end
    endgenerate

    // Pipeline Stage 1 registers for partial products
    reg [product_width-1:0] stage1_regs [0:size-1];
    integer idx;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (idx = 0; idx < size; idx = idx + 1) begin
                stage1_regs[idx] <= {product_width{1'b0}};
            end
        end else begin
            for (idx = 0; idx < size; idx = idx + 1) begin
                stage1_regs[idx] <= partial_products[idx];
            end
        end
    end

    // Combinational addition of partial products from stage1 registers
    wire [product_width-1:0] sum_partial_products;
    assign sum_partial_products = stage1_regs[0] 
                                 + stage1_regs[1] 
                                 + stage1_regs[2] 
                                 + stage1_regs[3];

    // Pipeline Stage 2 register for sum of partial products
    reg [product_width-1:0] stage2_reg;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            stage2_reg <= {product_width{1'b0}};
        else
            stage2_reg <= sum_partial_products;
    end

    // Output registered
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_out <= {product_width{1'b0}};
        else
            mul_out <= stage2_reg;
    end

endmodule