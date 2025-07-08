module multi_pipe_4bit #(
    parameter size = 4
)(
    input                   clk,
    input                   rst_n,
    input  [size-1:0]       mul_a,
    input  [size-1:0]       mul_b,
    output reg [(2*size)-1:0] mul_out
);

    // Extended inputs: prepend 'size' zeros on MSB side
    wire [2*size-1:0] ext_mul_a = { {size{1'b0}}, mul_a };
    wire [2*size-1:0] ext_mul_b = { {size{1'b0}}, mul_b };

    // Partial products array
    wire [2*size-1:0] partial_products [size-1:0];
    genvar i;
    generate
        for(i=0; i<size; i=i+1) begin : gen_partial_products
            assign partial_products[i] = (mul_b[i]) ? (ext_mul_a << i) : {2*size{1'b0}};
        end
    endgenerate

    // First pipeline stage registers to store sum of partial products for lower half bits
    reg [2*size-1:0] stage1_reg;
    // Second pipeline stage registers to store sum of partial products for upper half bits
    reg [2*size-1:0] stage2_reg;

    integer j;

    // On clk posedge or rst_n negedge, update pipeline registers
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            stage1_reg <= 0;
            stage2_reg <= 0;
            mul_out <= 0;
        end else begin
            // Accumulate partial products for lower half bits into stage1_reg
            // i = 0 to size/2-1
            stage1_reg <= {2*size{1'b0}};
            for (j = 0; j < size/2; j = j + 1) begin
                stage1_reg <= stage1_reg + partial_products[j];
            end
            // Accumulate partial products for upper half bits and add stage1_reg for stage2_reg
            stage2_reg <= {2*size{1'b0}};
            for (j = size/2; j < size; j = j + 1) begin
                stage2_reg <= stage2_reg + partial_products[j];
            end
            stage2_reg <= stage2_reg + stage1_reg;

            // Update output mul_out with stage2_reg value (final product)
            mul_out <= stage2_reg;
        end
    end

endmodule