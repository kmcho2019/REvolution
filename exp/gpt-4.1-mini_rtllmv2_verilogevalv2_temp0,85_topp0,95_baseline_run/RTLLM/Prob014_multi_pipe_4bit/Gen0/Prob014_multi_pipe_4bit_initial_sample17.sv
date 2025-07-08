module multi_pipe_4bit #(
    parameter size = 4
)(
    input clk,
    input rst_n,
    input  [size-1:0] mul_a,
    input  [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

    // Extend inputs by size zeros at MSB side
    wire [2*size-1:0] ext_mul_a = { {size{1'b0}}, mul_a };
    wire [2*size-1:0] ext_mul_b = { {size{1'b0}}, mul_b };

    // Generate partial products
    wire [2*size-1:0] partial_products [0:size-1];
    genvar i;
    generate
        for (i = 0; i < size; i = i + 1) begin : gen_partial_products
            assign partial_products[i] = mul_b[i] ? (ext_mul_a << i) : {2*size{1'b0}};
        end
    endgenerate

    // Pipeline stage 1 registers: sum partial_products[0] and partial_products[1]
    reg [2*size-1:0] stage1_sum0;
    // Pipeline stage 1 registers: sum partial_products[2] and partial_products[3]
    reg [2*size-1:0] stage1_sum1;

    // Pipeline stage 2 register: sum of the two stage1 sums
    reg [2*size-1:0] stage2_sum;

    // Stage 1: sum partial_products[0] and partial_products[1]
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage1_sum0 <= 0;
            stage1_sum1 <= 0;
        end else begin
            stage1_sum0 <= partial_products[0] + partial_products[1];
            stage1_sum1 <= partial_products[2] + partial_products[3];
        end
    end

    // Stage 2: sum stage1_sum0 and stage1_sum1
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage2_sum <= 0;
        end else begin
            stage2_sum <= stage1_sum0 + stage1_sum1;
        end
    end

    // Output register holds the final product
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out <= 0;
        end else begin
            mul_out <= stage2_sum;
        end
    end

endmodule