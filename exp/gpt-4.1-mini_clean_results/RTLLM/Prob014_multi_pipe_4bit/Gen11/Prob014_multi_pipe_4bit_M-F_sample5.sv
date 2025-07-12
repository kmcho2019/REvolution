module multi_pipe_4bit #(parameter size = 4) (
    input                   clk,
    input                   rst_n,
    input      [size-1:0]   mul_a,
    input      [size-1:0]   mul_b,
    output reg [2*size-1:0] mul_out
);

    // Extend multiplicand by 'size' zeros at MSB side
    wire [2*size-1:0] ext_mul_a = {{size{1'b0}}, mul_a};

    // Generate partial products combinationally
    wire [2*size-1:0] partial_products [0:size-1];

    genvar i;
    generate
        for (i=0; i<size; i=i+1) begin : gen_partial_products
            assign partial_products[i] = mul_b[i] ? (ext_mul_a << i) : {2*size{1'b0}};
        end
    endgenerate

    // --- Stage 1 registers for partial products and inputs ---
    // Declare individual registers for each partial product (flattened)
    // and for inputs stage1_mul_a and stage1_mul_b
    reg [2*size-1:0] stage1_partial_products_0;
    reg [2*size-1:0] stage1_partial_products_1;
    reg [2*size-1:0] stage1_partial_products_2;
    reg [2*size-1:0] stage1_partial_products_3;

    reg [2*size-1:0] stage1_mul_a;
    reg [size-1:0]   stage1_mul_b;

    // Generate register assignments
    // If size < 4, some registers are unused but harmless
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage1_mul_a <= {2*size{1'b0}};
            stage1_mul_b <= {size{1'b0}};
            stage1_partial_products_0 <= {2*size{1'b0}};
            stage1_partial_products_1 <= {2*size{1'b0}};
            stage1_partial_products_2 <= {2*size{1'b0}};
            stage1_partial_products_3 <= {2*size{1'b0}};
        end else begin
            stage1_mul_a <= ext_mul_a;
            stage1_mul_b <= mul_b;
            stage1_partial_products_0 <= partial_products[0];
            stage1_partial_products_1 <= (size > 1) ? partial_products[1] : {2*size{1'b0}};
            stage1_partial_products_2 <= (size > 2) ? partial_products[2] : {2*size{1'b0}};
            stage1_partial_products_3 <= (size > 3) ? partial_products[3] : {2*size{1'b0}};
        end
    end

    // --- Stage 2 combinational sum of partial products ---
    reg [2*size-1:0] stage2_sum;

    always @(*) begin
        stage2_sum = stage1_partial_products_0
                   + stage1_partial_products_1
                   + stage1_partial_products_2
                   + stage1_partial_products_3;
    end

    // --- Stage 2 register: output product ---
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out <= {2*size{1'b0}};
        end else begin
            mul_out <= stage2_sum;
        end
    end

endmodule