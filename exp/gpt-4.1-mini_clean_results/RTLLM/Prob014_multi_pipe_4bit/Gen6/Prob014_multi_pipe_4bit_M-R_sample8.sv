module multi_pipe_4bit #(
    parameter size = 4
)(
    input                  clk,
    input                  rst_n,
    input  [size-1:0]      mul_a,
    input  [size-1:0]      mul_b,
    output reg [2*size-1:0] mul_out
);

    // Proper zero-extension of multiplicand to 2*size bits (pad at MSB)
    wire [2*size-1:0] ext_mul_a = {{size{1'b0}}, mul_a};

    // Generate partial products for each bit of multiplier
    wire [2*size-1:0] partial_products [size-1:0];
    genvar i;
    generate
        for (i = 0; i < size; i = i + 1) begin : gen_partial_products
            assign partial_products[i] = mul_b[i] ? (ext_mul_a << i) : {2*size{1'b0}};
        end
    endgenerate

    // Stage 1 registers: sum partial products bits [0:1]
    reg [2*size-1:0] stage1_sum_low;
    // Stage 1 registers: sum partial products bits [2:3]
    reg [2*size-1:0] stage1_sum_high;

    // Stage 2 registers: pipeline stage 1 sums and output
    reg [2*size-1:0] stage2_sum_low;
    reg [2*size-1:0] stage2_sum_high;

    // Final stage registers: sum of stage2 partial sums
    reg [2*size-1:0] final_sum;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage1_sum_low  <= {2*size{1'b0}};
            stage1_sum_high <= {2*size{1'b0}};
            stage2_sum_low  <= {2*size{1'b0}};
            stage2_sum_high <= {2*size{1'b0}};
            final_sum       <= {2*size{1'b0}};
            mul_out         <= {2*size{1'b0}};
        end else begin
            // Stage 1 sums partial products from current inputs
            stage1_sum_low  <= partial_products[0] + partial_products[1];
            stage1_sum_high <= partial_products[2] + partial_products[3];

            // Stage 2 pipeline registers capture stage 1 sums from previous cycle
            stage2_sum_low  <= stage1_sum_low;
            stage2_sum_high <= stage1_sum_high;

            // Final sum registers sum stage2 pipeline outputs
            final_sum       <= stage2_sum_low + stage2_sum_high;

            // Output registered with final sum (result available after 2 cycles)
            mul_out         <= final_sum;
        end
    end

endmodule