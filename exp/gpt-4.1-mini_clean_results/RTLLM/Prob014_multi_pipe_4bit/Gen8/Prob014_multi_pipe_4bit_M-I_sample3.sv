module multi_pipe_4bit #(parameter size = 4) (
    input                   clk,
    input                   rst_n,
    input      [size-1:0]   mul_a,
    input      [size-1:0]   mul_b,
    output reg [2*size-1:0] mul_out
);

    // Extend inputs by adding 'size' zeros at MSB side of multiplicand
    // As problem states: extension by adding zero bits at most significant bit positions
    wire [2*size-1:0] ext_mul_a = {{size{1'b0}}, mul_a};

    // Stage 1 registers: register extended multiplicand and multiplier
    reg [2*size-1:0] stage1_ext_mul_a;
    reg [size-1:0]   stage1_mul_b;

    // Partial products after stage 1 registers (combinational)
    // Each partial product: if mul_b[i]==1, partial_product = ext_mul_a << i; else zero
    wire [2*size-1:0] partial_products [0:size-1];

    genvar i;
    generate
        for (i=0; i<size; i=i+1) begin : gen_partial_products
            assign partial_products[i] = stage1_mul_b[i] ? (stage1_ext_mul_a << i) : {2*size{1'b0}};
        end
    endgenerate

    // Sum of partial products combinational
    reg [2*size-1:0] sum_partial_products;

    integer j;
    always @(*) begin
        sum_partial_products = {2*size{1'b0}};
        for (j=0; j<size; j=j+1) begin
            sum_partial_products = sum_partial_products + partial_products[j];
        end
    end

    // Stage 2 register: store final sum and output product
    reg [2*size-1:0] stage2_sum;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage1_ext_mul_a <= {2*size{1'b0}};
            stage1_mul_b <= {size{1'b0}};
            stage2_sum <= {2*size{1'b0}};
            mul_out <= {2*size{1'b0}};
        end else begin
            // Stage 1 registers
            stage1_ext_mul_a <= ext_mul_a;
            stage1_mul_b <= mul_b;

            // Stage 2 register: latch sum of partial products
            stage2_sum <= sum_partial_products;

            // Output product updated with stage 2 sum
            mul_out <= stage2_sum;
        end
    end

endmodule