module multi_pipe_4bit #(
    parameter size = 4
)(
    input                   clk,
    input                   rst_n,
    input  [size-1:0]       mul_a,
    input  [size-1:0]       mul_b,
    output reg [2*size-1:0] mul_out
);

    // Extend multiplicand and multiplier by size zeros at MSB
    wire [2*size-1:0] ext_mul_a = { {size{1'b0}}, mul_a }; // MSB extended zeros
    wire [2*size-1:0] ext_mul_b = { {size{1'b0}}, mul_b }; // MSB extended zeros

    // Generate partial products - combinational logic
    // partial_products[i] = (mul_b[i]) ? (mul_a << i) else 0, zero-extended to 2*size bits
    wire [2*size-1:0] partial_products [0:size-1];

    genvar i;
    generate
        for (i = 0; i < size; i = i + 1) begin : gen_pp
            assign partial_products[i] = ext_mul_b[i] ? (ext_mul_a << i) : {2*size{1'b0}};
        end
    endgenerate

    // -------------------------------
    // Pipeline Stage 1 Registers:
    // Sum partial products in pairs to reduce addition tree depth.
    // For size=4, partial_products[0]+partial_products[1], partial_products[2]+partial_products[3]
    reg [2*size-1:0] stage1_sum [0:(size/2)-1];

    // -------------------------------
    // Pipeline Stage 2 Registers:
    // Sum the results from stage 1 to get the final product
    reg [2*size-1:0] stage2_sum;

    integer j;

    // Stage 1: Capture partial product sums
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (j=0; j<(size/2); j=j+1) begin
                stage1_sum[j] <= {2*size{1'b0}};
            end
        end else begin
            for (j=0; j<(size/2); j=j+1) begin
                stage1_sum[j] <= partial_products[2*j] + partial_products[2*j+1];
            end
        end
    end

    // Stage 2: Sum stage1 outputs to get final product
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage2_sum <= {2*size{1'b0}};
            mul_out    <= {2*size{1'b0}};
        end else begin
            stage2_sum <= stage1_sum[0] + stage1_sum[1];
            mul_out    <= stage2_sum;
        end
    end

endmodule