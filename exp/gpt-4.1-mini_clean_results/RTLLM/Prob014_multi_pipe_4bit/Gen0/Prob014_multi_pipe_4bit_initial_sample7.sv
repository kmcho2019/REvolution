module multi_pipe_4bit #(parameter size = 4) (
    input                clk,
    input                rst_n,
    input      [size-1:0] mul_a,
    input      [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

    // Extend inputs by size zeros at MSB side
    wire [2*size-1:0] a_ext = { {size{1'b0}}, mul_a };
    wire [2*size-1:0] b_ext = { {size{1'b0}}, mul_b };

    // Partial products generation
    wire [2*size-1:0] partial_products [size-1:0];
    genvar i;
    generate
        for(i=0; i<size; i=i+1) begin : gen_partial_products
            assign partial_products[i] = b_ext[i] ? (a_ext << i) : {2*size{1'b0}};
        end
    endgenerate

    // Two pipeline registers for intermediate sums
    // First stage: sum partial_products[0], partial_products[1], partial_products[2]
    // Second stage: add partial_products[3] and sum from first stage to produce final product
    reg [2*size-1:0] stage1_reg, stage2_reg;

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            stage1_reg <= {2*size{1'b0}};
            stage2_reg <= {2*size{1'b0}};
            mul_out    <= {2*size{1'b0}};
        end else begin
            // Stage 1: add first three partial products
            stage1_reg <= partial_products[0] + partial_products[1] + partial_products[2];

            // Stage 2: add fourth partial product with result from stage 1
            stage2_reg <= stage1_reg + partial_products[3];

            // Output updated with value from stage 2
            mul_out <= stage2_reg;
        end
    end

endmodule