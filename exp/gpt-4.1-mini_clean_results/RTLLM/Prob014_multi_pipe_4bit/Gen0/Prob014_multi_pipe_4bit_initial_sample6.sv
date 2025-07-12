module multi_pipe_4bit #(
    parameter size = 4
)(
    input                  clk,
    input                  rst_n,
    input  [size-1:0]      mul_a,
    input  [size-1:0]      mul_b,
    output reg [2*size-1:0] mul_out
);

    // Extend inputs by adding 'size' zeros at MSB side
    wire [2*size-1:0] ext_mul_a = { {size{1'b0}}, mul_a };
    wire [2*size-1:0] ext_mul_b = { {size{1'b0}}, mul_b };

    // Generate partial products for each bit of mul_b
    // partial_product[i] = (mul_b[i] == 1) ? (mul_a << i) : 0
    wire [2*size-1:0] partial_products [0:size-1];
    genvar i;
    generate
        for (i=0; i<size; i=i+1) begin : gen_partial_products
            assign partial_products[i] = mul_b[i] ? (ext_mul_a << i) : {2*size{1'b0}};
        end
    endgenerate

    // Registers to hold intermediate sums (pipeline registers)
    // First level register sum of partial_products[0] to partial_products[size/2-1]
    // Second level register sum of partial_products[size/2] to partial_products[size-1]
    // Then final sum of these two registers -> mul_out

    localparam half = size/2;

    reg [2*size-1:0] sum_stage1;
    reg [2*size-1:0] sum_stage2;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_stage1 <= 0;
            sum_stage2 <= 0;
        end else begin
            // Sum first half partial products
            // partial_products[0] + partial_products[1] + ... + partial_products[half-1]
            integer idx;
            reg [2*size-1:0] sum1_tmp;
            reg [2*size-1:0] sum2_tmp;
            sum1_tmp = 0;
            sum2_tmp = 0;
            for (idx = 0; idx < half; idx = idx + 1) begin
                sum1_tmp = sum1_tmp + partial_products[idx];
            end
            for (idx = half; idx < size; idx = idx + 1) begin
                sum2_tmp = sum2_tmp + partial_products[idx];
            end
            sum_stage1 <= sum1_tmp;
            sum_stage2 <= sum2_tmp;
        end
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out <= 0;
        end else begin
            // Final sum of the two stage registers
            mul_out <= sum_stage1 + sum_stage2;
        end
    end

endmodule