module multi_pipe_4bit #(
    parameter size = 4
)(
    input                   clk,
    input                   rst_n,
    input  [size-1:0]       mul_a,
    input  [size-1:0]       mul_b,
    output reg [2*size-1:0] mul_out
);

    // Extended inputs: zero-extend by size bits at MSB
    wire [2*size-1:0] ext_mul_a = { {size{1'b0}}, mul_a };
    wire [2*size-1:0] ext_mul_b = { {size{1'b0}}, mul_b };

    // Partial products array
    wire [2*size-1:0] partial_products [0:size-1];

    genvar i;
    generate
        for(i=0; i<size; i=i+1) begin : gen_partial_products
            assign partial_products[i] = (ext_mul_b[i] == 1'b1) ? (ext_mul_a << i) : {2*size{1'b0}};
        end
    endgenerate

    // Two pipeline registers to store intermediate sums
    reg [2*size-1:0] stage1_sum;  // after first pipeline stage
    reg [2*size-1:0] stage2_sum;  // after second pipeline stage (final sum before output)

    integer j;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage1_sum <= 0;
            stage2_sum <= 0;
            mul_out    <= 0;
        end else begin
            // First pipeline stage: sum of first half partial products
            // sum partial_products[0 to size/2-1]
            stage1_sum <= {2*size{1'b0}};
            for (j = 0; j < size/2; j = j + 1) begin
                stage1_sum <= stage1_sum + partial_products[j];
            end

            // Second pipeline stage: sum of second half partial products plus stage1_sum
            // This sum will be assigned to stage2_sum on next clock cycle
            // But since we need two pipeline stages, we use a separate always block below
        end
    end

    // Second pipeline stage and output register update
    // To implement two pipeline stages, we update stage2_sum and mul_out on next clock cycle
    reg [2*size-1:0] partial_sum_second_half;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            partial_sum_second_half <= 0;
            stage2_sum <= 0;
            mul_out <= 0;
        end else begin
            // sum partial_products[size/2 to size-1]
            partial_sum_second_half <= {2*size{1'b0}};
            for (j = size/2; j < size; j = j + 1) begin
                partial_sum_second_half <= partial_sum_second_half + partial_products[j];
            end

            // stage2_sum is sum of stage1_sum + sum of second half partial products
            stage2_sum <= stage1_sum + partial_sum_second_half;

            // Output register updated with stage2_sum
            mul_out <= stage2_sum;
        end
    end

endmodule