module multi_pipe_4bit #(parameter size = 4) (
    input                   clk,
    input                   rst_n,
    input      [size-1:0]   mul_a,
    input      [size-1:0]   mul_b,
    output reg [2*size-1:0] mul_out
);

    // Extend inputs by padding 'size' zeros at LSB side of multiplicand
    // This corresponds to (mul_a << size)
    wire [2*size-1:0] ext_mul_a = {mul_a, {size{1'b0}}};

    // Stage 1 registers: store inputs and partial products
    reg [size-1:0]          stage1_mul_b;
    reg [2*size-1:0]        stage1_ext_mul_a;
    reg [2*size-1:0]        stage1_partial_products [0:size-1];

    // Stage 2 register: sum of partial products
    reg [2*size-1:0]        stage2_sum;

    genvar i;

    // Generate partial products combinationally (before stage 1 registers)
    wire [2*size-1:0] partial_products_comb [0:size-1];
    generate
        for (i = 0; i < size; i = i + 1) begin : gen_partial_products_comb
            // If mul_b[i] == 1, partial product = ext_mul_a shifted right by i bits
            // Since ext_mul_a is (mul_a << size), shifting right by i aligns partial products correctly:
            // This is equivalent to partial_product = mul_a << (size - i)
            assign partial_products_comb[i] = (mul_b[i]) ? (ext_mul_a >> i) : {2*size{1'b0}};
        end
    endgenerate

    integer j;

    // Stage 1: Register inputs and partial products generated from inputs
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage1_mul_b <= {size{1'b0}};
            stage1_ext_mul_a <= {2*size{1'b0}};
            for (j = 0; j < size; j = j + 1) begin
                stage1_partial_products[j] <= {2*size{1'b0}};
            end
        end else begin
            stage1_mul_b <= mul_b;
            stage1_ext_mul_a <= ext_mul_a;
            for (j = 0; j < size; j = j + 1) begin
                stage1_partial_products[j] <= partial_products_comb[j];
            end
        end
    end

    // Stage 2: Sum registered partial products and register output product
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage2_sum <= {2*size{1'b0}};
            mul_out <= {2*size{1'b0}};
        end else begin
            // Sum partial products from stage 1 registers
            stage2_sum <= {2*size{1'b0}};
            for (j = 0; j < size; j = j + 1) begin
                stage2_sum <= stage2_sum + stage1_partial_products[j];
            end

            // Register the final output product
            mul_out <= stage2_sum;
        end
    end

endmodule