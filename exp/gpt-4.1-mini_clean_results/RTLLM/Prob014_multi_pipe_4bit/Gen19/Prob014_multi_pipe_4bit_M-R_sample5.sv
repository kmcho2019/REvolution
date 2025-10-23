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

    // Partial products combinationally generated
    wire [(2*size)-1:0] pp [size-1:0];
    genvar i;
    generate
        for (i = 0; i < size; i = i + 1) begin : gen_pp
            assign pp[i] = mul_b[i] ? (ext_mul_a << i) : {(2*size){1'b0}};
        end
    endgenerate

    // Sum partial products pairwise (combinational sums)
    wire [(2*size)-1:0] sum_stage1_0 = pp[0] + pp[1];
    wire [(2*size)-1:0] sum_stage1_1 = pp[2] + pp[3];

    // Pipeline registers for stage 1 sums
    reg [(2*size)-1:0] stage1_reg0;
    reg [(2*size)-1:0] stage1_reg1;

    // Pipeline register for stage 2 sum and final output register
    reg [(2*size)-1:0] stage2_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage1_reg0 <= {(2*size){1'b0}};
            stage1_reg1 <= {(2*size){1'b0}};
            stage2_reg  <= {(2*size){1'b0}};
            mul_out     <= {(2*size){1'b0}};
        end else begin
            // Stage 1 pipeline registers latch pairwise sums
            stage1_reg0 <= sum_stage1_0;
            stage1_reg1 <= sum_stage1_1;

            // Stage 2 pipeline register sums stage1 registers
            stage2_reg  <= stage1_reg0 + stage1_reg1;

            // Output register holds final product
            mul_out     <= stage2_reg;
        end
    end

endmodule