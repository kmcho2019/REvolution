module multi_pipe_4bit #(
    parameter size = 4
)(
    input                   clk,
    input                   rst_n,
    input       [size-1:0]  mul_a,
    input       [size-1:0]  mul_b,
    output reg  [(2*size)-1:0] mul_out
);

    // Extended inputs by prepending size zeros at MSB
    wire [(2*size)-1:0] ext_a = { {size{1'b0}}, mul_a };
    wire [(2*size)-1:0] ext_b = { {size{1'b0}}, mul_b };

    // Generate partial products combinationally
    wire [(2*size)-1:0] partial_product [size-1:0];
    genvar i;
    generate
        for (i = 0; i < size; i = i + 1) begin : gen_partial_products
            assign partial_product[i] = ext_b[i] ? (ext_a << i) : { (2*size){1'b0} };
        end
    endgenerate

    // Combinational sums of pairs of partial products
    wire [(2*size)-1:0] sum_pair0 = partial_product[0] + partial_product[1];
    wire [(2*size)-1:0] sum_pair1 = partial_product[2] + partial_product[3];

    // Pipeline registers for intermediate sums
    reg [(2*size)-1:0] reg_stage1_0;
    reg [(2*size)-1:0] reg_stage1_1;

    // Pipeline register for final sum
    reg [(2*size)-1:0] reg_stage2;

    // Stage 1 pipeline registers: capture sums of partial products pairs
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            reg_stage1_0 <= {(2*size){1'b0}};
            reg_stage1_1 <= {(2*size){1'b0}};
        end else begin
            reg_stage1_0 <= sum_pair0;
            reg_stage1_1 <= sum_pair1;
        end
    end

    // Stage 2 pipeline register: sum of stage 1 registers and update output product
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            reg_stage2 <= {(2*size){1'b0}};
            mul_out   <= {(2*size){1'b0}};
        end else begin
            reg_stage2 <= reg_stage1_0 + reg_stage1_1;
            mul_out   <= reg_stage2;
        end
    end

endmodule