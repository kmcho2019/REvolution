module multi_pipe_4bit #(parameter size = 4) (
    input                   clk,
    input                   rst_n,
    input      [size-1:0]   mul_a,
    input      [size-1:0]   mul_b,
    output reg [2*size-1:0] mul_out
);

    // Extend multiplicand by adding 'size' zero bits at MSB side
    // ext_mul_a = {size zeros, mul_a}
    wire [2*size-1:0] ext_mul_a = {{size{1'b0}}, mul_a};

    genvar i;

    // Generate combinational partial products: 
    // partial_product[i] = (mul_b[i] ? (ext_mul_a << i) : 0)
    wire [2*size-1:0] partial_products_comb [size-1:0];
    generate
        for (i = 0; i < size; i = i + 1) begin : gen_partial_products
            assign partial_products_comb[i] = mul_b[i] ? (ext_mul_a << i) : {2*size{1'b0}};
        end
    endgenerate

    // Stage 1 registers: register partial products
    reg [2*size-1:0] stage1_partial_products [size-1:0];

    integer j;
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (j = 0; j < size; j = j + 1) begin
                stage1_partial_products[j] <= {2*size{1'b0}};
            end
        end else begin
            for (j = 0; j < size; j = j + 1) begin
                stage1_partial_products[j] <= partial_products_comb[j];
            end
        end
    end

    // Stage 2 combinational sum of partial products from stage1 registers
    // Sum explicitly without a function passing an unpacked array
    wire [2*size-1:0] stage2_sum_comb;
    assign stage2_sum_comb = stage1_partial_products[0]
                            + stage1_partial_products[1]
                            + stage1_partial_products[2]
                            + stage1_partial_products[3];

    // Stage 2 register: register the final sum and produce output
    reg [2*size-1:0] stage2_sum_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage2_sum_reg <= {2*size{1'b0}};
            mul_out <= {2*size{1'b0}};
        end else begin
            stage2_sum_reg <= stage2_sum_comb;
            mul_out <= stage2_sum_reg;
        end
    end

endmodule