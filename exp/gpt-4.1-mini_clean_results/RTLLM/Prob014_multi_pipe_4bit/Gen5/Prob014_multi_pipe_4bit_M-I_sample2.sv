module multi_pipe_4bit #(
    parameter size = 4
)(
    input                   clk,
    input                   rst_n,
    input  [size-1:0]       mul_a,
    input  [size-1:0]       mul_b,
    output reg [2*size-1:0] mul_out
);

    // Extend multiplicand and multiplier by size zeros at LSB (for proper shifting)
    wire [2*size-1:0] ext_mul_a = {mul_a, {size{1'b0}}}; // multiplicand shifted for max product width
    wire [2*size-1:0] ext_mul_b = {mul_b, {size{1'b0}}}; // multiplier extended similarly (unused directly but consistent)

    // Partial products generation using generate block
    // For each bit i in multiplier, generate partial product = (bit mul_b[i]) ? (ext_mul_a << i) : 0
    wire [2*size-1:0] partial_products [0:size-1];
    genvar i;
    generate
        for(i=0; i<size; i=i+1) begin : gen_partial_products
            assign partial_products[i] = mul_b[i] ? (ext_mul_a << i) : {2*size{1'b0}};
        end
    endgenerate

    // Two pipeline register levels to store intermediate sums
    // Stage 1: sum partial products of lower half bits (bits 0 and 1)
    reg [2*size-1:0] stage1_sum_low;
    // Stage 1: sum partial products of upper half bits (bits 2 and 3)
    reg [2*size-1:0] stage1_sum_high;

    // Stage 2: sum of stage1 registers (final product)
    reg [2*size-1:0] stage2_sum;

    // Synchronous pipeline update and reset behavior
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage1_sum_low  <= {2*size{1'b0}};
            stage1_sum_high <= {2*size{1'b0}};
            stage2_sum      <= {2*size{1'b0}};
            mul_out         <= {2*size{1'b0}};
        end else begin
            // Sum partial products bits 0 and 1 in stage 1 low register
            stage1_sum_low  <= partial_products[0] + partial_products[1];
            // Sum partial products bits 2 and 3 in stage 1 high register
            stage1_sum_high <= partial_products[2] + partial_products[3];
            // Stage 2 sums the two stage 1 sums to produce final product
            stage2_sum      <= stage1_sum_low + stage1_sum_high;
            // Output updated with final product
            mul_out         <= stage2_sum;
        end
    end

endmodule