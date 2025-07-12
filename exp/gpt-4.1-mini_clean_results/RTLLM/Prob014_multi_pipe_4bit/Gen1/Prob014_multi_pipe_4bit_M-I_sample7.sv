module multi_pipe_4bit #(
    parameter size = 4
)(
    input                    clk,
    input                    rst_n,
    input  [size-1:0]        mul_a,
    input  [size-1:0]        mul_b,
    output reg [2*size-1:0]  mul_out
);

    // Extend multiplicand by size zeros at MSB side
    wire [2*size-1:0] ext_mul_a = { {size{1'b0}}, mul_a };

    // Generate partial products combinationally
    wire [2*size-1:0] partial_products [0:size-1];
    genvar i;
    generate
        for (i = 0; i < size; i = i + 1) begin : gen_partial_products
            assign partial_products[i] = mul_b[i] ? (ext_mul_a << i) : {2*size{1'b0}};
        end
    endgenerate

    // Balanced adder tree for first pipeline stage:
    // Sum lower half partial products combinationally -> sum_low
    // Sum upper half partial products combinationally -> sum_high
    // Registers store sum_low and sum_high as first pipeline stage.

    localparam half = size / 2;

    // Combinational sums of lower half partial products
    wire [2*size-1:0] sum_low_level1 [0:half-1];
    wire [2*size-1:0] sum_low_level2 [0:(half/2)-1];
    wire [2*size-1:0] sum_low;

    // Stage 1 summation of lower half partial products
    generate
        for (i = 0; i < half; i = i + 1) begin : gen_sum_low_level1
            assign sum_low_level1[i] = partial_products[i];
        end
    endgenerate

    // Reduce pairwise sums until a single sum is left (adder tree)
    // For half = 2 (size=4), this is just one addition
    generate
        if (half == 2) begin
            assign sum_low_level2[0] = sum_low_level1[0] + sum_low_level1[1];
            assign sum_low = sum_low_level2[0];
        end else if (half == 1) begin
            assign sum_low = sum_low_level1[0];
        end else begin
            // For larger sizes, extend adder tree as needed
            // For size=4 this path won't be used
            assign sum_low = {2*size{1'b0}};
        end
    endgenerate

    // Combinational sums of upper half partial products
    wire [2*size-1:0] sum_high_level1 [0:size - half - 1];
    wire [2*size-1:0] sum_high_level2;

    generate
        for (i = half; i < size; i = i + 1) begin : gen_sum_high_level1
            assign sum_high_level1[i - half] = partial_products[i];
        end
    endgenerate

    // For size=4, upper half has 2 partial products
    generate
        if (size - half == 2) begin
            assign sum_high_level2 = sum_high_level1[0] + sum_high_level1[1];
        end else if (size - half == 1) begin
            assign sum_high_level2 = sum_high_level1[0];
        end else begin
            // For larger sizes, extend adder tree as needed
            assign sum_high_level2 = {2*size{1'b0}};
        end
    endgenerate

    // Pipeline registers for first stage sums
    reg [2*size-1:0] sum_low_reg;
    reg [2*size-1:0] sum_high_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_low_reg <= 0;
            sum_high_reg <= 0;
        end else begin
            sum_low_reg <= sum_low;
            sum_high_reg <= sum_high_level2;
        end
    end

    // Second pipeline stage: final sum of the two registers to produce output
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out <= 0;
        end else begin
            mul_out <= sum_low_reg + sum_high_reg;
        end
    end

endmodule