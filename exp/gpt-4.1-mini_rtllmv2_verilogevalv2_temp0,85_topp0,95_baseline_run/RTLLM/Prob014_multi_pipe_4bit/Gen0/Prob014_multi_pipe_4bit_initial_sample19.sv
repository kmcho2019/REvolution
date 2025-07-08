module multi_pipe_4bit #(
    parameter size = 4
)(
    input                   clk,
    input                   rst_n,
    input   [size-1:0]      mul_a,
    input   [size-1:0]      mul_b,
    output reg [2*size-1:0] mul_out
);

    // Extended inputs by adding size zeros at MSB side
    wire [2*size-1:0] ext_mul_a = { {size{1'b0}}, mul_a };
    wire [2*size-1:0] ext_mul_b = { {size{1'b0}}, mul_b }; // Not directly used in multiplication, only mul_b bits used below

    // Partial products array
    wire [2*size-1:0] partial_products [0:size-1];

    genvar i;
    generate
        for (i=0; i<size; i=i+1) begin : gen_pp
            assign partial_products[i] = (mul_b[i]) ? (ext_mul_a << i) : {2*size{1'b0}};
        end
    endgenerate

    // Two pipeline registers stages for partial sums
    // We split the partial products additions into two groups:
    // Stage 1: sum partial_products[0..1] and partial_products[2..3]
    // Stage 2: sum the two stage 1 sums

    reg [2*size-1:0] stage1_reg0, stage1_reg1;
    reg [2*size-1:0] stage2_reg;

    // Stage 1: Calculate sums of partial products pairs
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage1_reg0 <= 0;
            stage1_reg1 <= 0;
        end else begin
            stage1_reg0 <= partial_products[0] + partial_products[1];
            stage1_reg1 <= partial_products[2] + partial_products[3];
        end
    end

    // Stage 2: Calculate final sum of stage1_reg0 and stage1_reg1
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage2_reg <= 0;
            mul_out <= 0;
        end else begin
            stage2_reg <= stage1_reg0 + stage1_reg1;
            mul_out <= stage2_reg;
        end
    end

endmodule