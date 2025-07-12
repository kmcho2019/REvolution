module multi_pipe_4bit #(
    parameter size = 4
)(
    input                    clk,
    input                    rst_n,
    input  [size-1:0]        mul_a,
    input  [size-1:0]        mul_b,
    output reg [2*size-1:0]  mul_out
);

    // Extend inputs by concatenating size zeros at MSB side as per problem
    wire [2*size-1:0] ext_mul_a = { {size{1'b0}}, mul_a };  // MSB zeros + mul_a LSBs
    wire [2*size-1:0] ext_mul_b = { {size{1'b0}}, mul_b };

    // Partial products for each bit of multiplier
    wire [2*size-1:0] partial_products [0:size-1];

    genvar i;
    generate
        for (i = 0; i < size; i = i + 1) begin : gen_pp
            // If mul_b[i] == 1, partial product = ext_mul_a shifted left by i bits
            // Else zero
            assign partial_products[i] = ext_mul_b[size + i] ? (ext_mul_a << i) : {2*size{1'b0}};
            // Note: ext_mul_b has size zeros at MSB, actual mul_b bits start from index size,
            // so ext_mul_b[size + i] corresponds to mul_b[i].
        end
    endgenerate

    // -------------------------
    // Pipeline registers

    // Stage 1 registers - store first half of partial products sum
    reg [2*size-1:0] stage1_sum;

    // Stage 2 registers - store second half sum + stage1_sum
    reg [2*size-1:0] stage2_sum;

    integer j;

    // Combinational sum signals for pipeline stages
    wire [2*size-1:0] first_half_sum;
    wire [2*size-1:0] second_half_sum;

    // Sum lower half partial products (0 to size/2-1)
    wire [2*size-1:0] lower_half_sum_wire = {2*size{1'b0}};
    // Sum upper half partial products (size/2 to size-1)
    wire [2*size-1:0] upper_half_sum_wire = {2*size{1'b0}};

    // Because size might be 4, size/2 = 2, sum partial_products[0..1] and [2..3]

    // Sum generation loops: sum partial products in first and second half combinationally
    reg [2*size-1:0] lower_half_sum;
    reg [2*size-1:0] upper_half_sum;

    always @(*) begin
        lower_half_sum = {2*size{1'b0}};
        for (j = 0; j < size/2; j = j + 1) begin
            lower_half_sum = lower_half_sum + partial_products[j];
        end

        upper_half_sum = {2*size{1'b0}};
        for (j = size/2; j < size; j = j + 1) begin
            upper_half_sum = upper_half_sum + partial_products[j];
        end
    end

    // -------------------------
    // Pipeline logic: registers capturing sums in two stages

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage1_sum <= {2*size{1'b0}};
            stage2_sum <= {2*size{1'b0}};
            mul_out    <= {2*size{1'b0}};
        end else begin
            // Stage 1 captures sum of first half partial products
            stage1_sum <= lower_half_sum;

            // Stage 2 adds upper half partial products to stage1_sum from previous cycle
            stage2_sum <= stage1_sum + upper_half_sum;

            // Output updated from stage 2 register
            mul_out <= stage2_sum;
        end
    end

endmodule