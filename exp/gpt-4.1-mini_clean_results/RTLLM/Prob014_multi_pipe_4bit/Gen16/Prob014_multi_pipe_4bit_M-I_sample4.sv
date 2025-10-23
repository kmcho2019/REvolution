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

    // Stage 1 registers: store partial products
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

    // Stage 2 registers: sum pairs of partial products to reduce additions in final stage
    reg [product_width-1:0] sum_01_reg;
    reg [product_width-1:0] sum_23_reg;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_01_reg <= {product_width{1'b0}};
            sum_23_reg <= {product_width{1'b0}};
        end else begin
            sum_01_reg <= stage1_regs[0] + stage1_regs[1];
            sum_23_reg <= stage1_regs[2] + stage1_regs[3];
        end
    end

    // Stage 3 register: final sum of the two intermediate sums
    reg [product_width-1:0] stage3_reg;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage3_reg <= {product_width{1'b0}};
        end else begin
            stage3_reg <= sum_01_reg + sum_23_reg;
        end
    end

    // Output registered from stage 3
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            mul_out <= {product_width{1'b0}};
        else
            mul_out <= stage3_reg;
    end

endmodule