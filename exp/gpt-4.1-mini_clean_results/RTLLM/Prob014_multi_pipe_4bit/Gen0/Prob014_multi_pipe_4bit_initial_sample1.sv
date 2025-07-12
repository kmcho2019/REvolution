module multi_pipe_4bit #(
    parameter size = 4
)(
    input                   clk,
    input                   rst_n,
    input       [size-1:0]  mul_a,
    input       [size-1:0]  mul_b,
    output reg  [(2*size)-1:0] mul_out
);

    // Extended inputs with size zeros at MSB side
    wire [(2*size)-1:0] ext_a = { {size{1'b0}}, mul_a };
    wire [(2*size)-1:0] ext_b = { {size{1'b0}}, mul_b };

    // Generate partial products
    wire [(2*size)-1:0] partial_product [size-1:0];
    genvar i;
    generate
        for (i=0; i<size; i=i+1) begin : gen_partial_products
            assign partial_product[i] = ext_b[i] ? (ext_a << i) : { (2*size){1'b0} };
        end
    endgenerate

    // First stage registers to hold sums of partial products [0] + [1] and [2] + [3]
    reg [(2*size)-1:0] reg_stage1_0;
    reg [(2*size)-1:0] reg_stage1_1;

    // Second stage register for final product summation
    reg [(2*size)-1:0] reg_stage2;

    // Pipeline stage 1: sum partial products 0 and 1, 2 and 3
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            reg_stage1_0 <= 0;
            reg_stage1_1 <= 0;
        end else begin
            reg_stage1_0 <= partial_product[0] + partial_product[1];
            reg_stage1_1 <= partial_product[2] + partial_product[3];
        end
    end

    // Pipeline stage 2: sum results from stage 1 and output product
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            reg_stage2 <= 0;
            mul_out   <= 0;
        end else begin
            reg_stage2 <= reg_stage1_0 + reg_stage1_1;
            mul_out   <= reg_stage2;
        end
    end

endmodule