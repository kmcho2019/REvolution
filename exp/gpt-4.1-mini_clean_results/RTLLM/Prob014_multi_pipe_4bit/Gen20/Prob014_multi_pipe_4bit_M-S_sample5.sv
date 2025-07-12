module multi_pipe_4bit #(
    parameter size = 4
)(
    input                       clk,
    input                       rst_n,
    input       [size-1:0]      mul_a,
    input       [size-1:0]      mul_b,
    output reg  [(2*size)-1:0]  mul_out
);

    // Extend multiplicand by size zeros on MSB
    wire [(2*size)-1:0] ext_mul_a = { {(size){1'b0}}, mul_a };

    // Partial products
    wire [(2*size)-1:0] pp [size-1:0];
    genvar i;
    generate
        for (i = 0; i < size; i = i + 1) begin : gen_pp
            assign pp[i] = mul_b[i] ? (ext_mul_a << i) : {(2*size){1'b0}};
        end
    endgenerate

    // Pipeline registers for intermediate sums
    reg [(2*size)-1:0] stage1_reg;
    reg [(2*size)-1:0] stage2_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage1_reg <= {(2*size){1'b0}};
            stage2_reg <= {(2*size){1'b0}};
            mul_out    <= {(2*size){1'b0}};
        end else begin
            // Stage 1: sum partial products 0, 1 and 2
            stage1_reg <= pp[0] + pp[1] + pp[2];
            // Stage 2: add partial product 3 and output
            stage2_reg <= stage1_reg + pp[3];
            mul_out    <= stage2_reg;
        end
    end

endmodule