module multi_pipe_4bit #(
    parameter size = 4
)(
    input                       clk,
    input                       rst_n,
    input       [size-1:0]      mul_a,
    input       [size-1:0]      mul_b,
    output reg  [(2*size)-1:0]  mul_out
);

    // Extend multiplicand by 'size' zeros at MSB side (high bits)
    wire [(2*size)-1:0] ext_mul_a = { {(size){1'b0}}, mul_a };

    // Partial products for each bit of mul_b
    wire [(2*size)-1:0] pp0 = mul_b[0] ? (ext_mul_a << 0) : { (2*size){1'b0} };
    wire [(2*size)-1:0] pp1 = mul_b[1] ? (ext_mul_a << 1) : { (2*size){1'b0} };
    wire [(2*size)-1:0] pp2 = mul_b[2] ? (ext_mul_a << 2) : { (2*size){1'b0} };
    wire [(2*size)-1:0] pp3 = mul_b[3] ? (ext_mul_a << 3) : { (2*size){1'b0} };

    // Stage 1 pipeline registers - sum partial products pairwise
    reg [(2*size)-1:0] stage1_reg0, stage1_reg1;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage1_reg0 <= { (2*size){1'b0} };
            stage1_reg1 <= { (2*size){1'b0} };
        end else begin
            stage1_reg0 <= pp0 + pp1; // sum partial products 0 and 1
            stage1_reg1 <= pp2 + pp3; // sum partial products 2 and 3
        end
    end

    // Stage 2 pipeline register - sum stage1 results for final product
    reg [(2*size)-1:0] stage2_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage2_reg <= { (2*size){1'b0} };
            mul_out   <= { (2*size){1'b0} };
        end else begin
            stage2_reg <= stage1_reg0 + stage1_reg1; // sum stage1 pipeline registers
            mul_out   <= stage2_reg;                 // output final product
        end
    end

endmodule