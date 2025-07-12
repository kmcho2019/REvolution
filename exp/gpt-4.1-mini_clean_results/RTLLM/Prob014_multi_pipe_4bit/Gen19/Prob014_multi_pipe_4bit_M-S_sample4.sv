module multi_pipe_4bit #(
    parameter size = 4
)(
    input                   clk,
    input                   rst_n,
    input   [size-1:0]      mul_a,
    input   [size-1:0]      mul_b,
    output reg [(2*size)-1:0] mul_out
);

    // Extend multiplicand by size zeros at MSB
    wire [(2*size)-1:0] ext_mul_a = { {(size){1'b0}}, mul_a };

    // Generate partial products without generate block
    wire [(2*size)-1:0] pp0 = mul_b[0] ? (ext_mul_a << 0) : 0;
    wire [(2*size)-1:0] pp1 = mul_b[1] ? (ext_mul_a << 1) : 0;
    wire [(2*size)-1:0] pp2 = mul_b[2] ? (ext_mul_a << 2) : 0;
    wire [(2*size)-1:0] pp3 = mul_b[3] ? (ext_mul_a << 3) : 0;

    // Stage 1 registers: sum partial products pairwise
    reg [(2*size)-1:0] stage1_0, stage1_1;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage1_0 <= 0;
            stage1_1 <= 0;
        end else begin
            stage1_0 <= pp0 + pp1;
            stage1_1 <= pp2 + pp3;
        end
    end

    // Stage 2 register: sum stage1 results and output product
    reg [(2*size)-1:0] stage2;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage2 <= 0;
            mul_out <= 0;
        end else begin
            stage2 <= stage1_0 + stage1_1;
            mul_out <= stage2;
        end
    end

endmodule