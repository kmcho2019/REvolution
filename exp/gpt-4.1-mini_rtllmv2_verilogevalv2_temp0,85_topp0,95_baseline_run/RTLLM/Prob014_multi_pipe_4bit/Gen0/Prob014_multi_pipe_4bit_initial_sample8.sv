module multi_pipe_4bit #(
    parameter size = 4
)(
    input                     clk,
    input                     rst_n,
    input      [size-1:0]     mul_a,
    input      [size-1:0]     mul_b,
    output reg [2*size-1:0]   mul_out
);

    // Extended multiplicand and multiplier (zero-extended at MSB)
    wire [2*size-1:0] mul_a_ext = { {size{1'b0}}, mul_a };
    wire [2*size-1:0] mul_b_ext = { {size{1'b0}}, mul_b };

    // Partial products array
    wire [2*size-1:0] partial_products [size-1:0];
    genvar i;
    generate
        for(i=0; i<size; i=i+1) begin : PARTIAL_PRODUCT_GEN
            assign partial_products[i] = mul_b[i] ? (mul_a_ext << i) : {2*size{1'b0}};
        end
    endgenerate

    // Registers for the first pipeline stage: sum partial products in two halves
    reg [2*size-1:0] sum_stage1_0; // sum of partial_products[0] and partial_products[1]
    reg [2*size-1:0] sum_stage1_1; // sum of partial_products[2] and partial_products[3]

    // Registers for the second pipeline stage: final sum of stage1 sums
    reg [2*size-1:0] sum_stage2;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_stage1_0 <= 0;
            sum_stage1_1 <= 0;
            sum_stage2   <= 0;
            mul_out      <= 0;
        end else begin
            // First pipeline stage: sum pairs of partial products
            sum_stage1_0 <= partial_products[0] + partial_products[1];
            sum_stage1_1 <= partial_products[2] + partial_products[3];
            // Second pipeline stage: sum previous sums
            sum_stage2   <= sum_stage1_0 + sum_stage1_1;
            // Output stage: update final product output
            mul_out      <= sum_stage2;
        end
    end

endmodule