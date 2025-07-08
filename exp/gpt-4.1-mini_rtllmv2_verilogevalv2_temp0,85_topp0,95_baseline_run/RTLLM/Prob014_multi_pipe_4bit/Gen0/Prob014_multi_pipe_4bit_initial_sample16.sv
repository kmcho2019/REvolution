module multi_pipe_4bit #
(
    parameter size = 4
)
(
    input  wire                  clk,
    input  wire                  rst_n,
    input  wire [size-1:0]       mul_a,
    input  wire [size-1:0]       mul_b,
    output reg  [(2*size)-1:0]   mul_out
);

    // Extend inputs by prepending 'size' zeros at MSB side
    wire [(2*size)-1:0] a_ext = { {(size){1'b0}}, mul_a };
    wire [(2*size)-1:0] b_ext = { {(size){1'b0}}, mul_b };

    // Partial products array
    wire [(2*size)-1:0] partial_products [size-1:0];

    genvar i;
    generate
        for (i=0; i<size; i=i+1) begin : gen_partial_products
            assign partial_products[i] = b_ext[i] ? (a_ext << i) : { (2*size){1'b0} };
        end
    endgenerate

    // First pipeline stage registers: sum pairs of partial products
    // Since size=4, partial_products[0..3]
    // stage1_reg0 = partial_products[0] + partial_products[1]
    // stage1_reg1 = partial_products[2] + partial_products[3]

    reg [(2*size)-1:0] stage1_reg0;
    reg [(2*size)-1:0] stage1_reg1;

    // Second pipeline stage register: sum stage1_reg0 + stage1_reg1
    reg [(2*size)-1:0] stage2_reg;

    // Pipeline logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage1_reg0 <= { (2*size){1'b0} };
            stage1_reg1 <= { (2*size){1'b0} };
            stage2_reg  <= { (2*size){1'b0} };
            mul_out     <= { (2*size){1'b0} };
        end else begin
            // First pipeline stage: sum partial products in pairs
            stage1_reg0 <= partial_products[0] + partial_products[1];
            stage1_reg1 <= partial_products[2] + partial_products[3];
            // Second pipeline stage: sum stage1_reg0 + stage1_reg1
            stage2_reg  <= stage1_reg0 + stage1_reg1;
            // Output the final product
            mul_out     <= stage2_reg;
        end
    end

endmodule