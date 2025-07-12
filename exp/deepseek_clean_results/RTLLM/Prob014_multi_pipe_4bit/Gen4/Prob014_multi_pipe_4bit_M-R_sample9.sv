module multi_pipe_4bit #(
    parameter size = 4
) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

    // Extended inputs with zeros at MSB
    wire [2*size-1:0] a_ext = {{size{1'b0}}, mul_a};
    wire [2*size-1:0] b_ext = {{size{1'b0}}, mul_b};

    // Partial products generation using assign
    wire [2*size-1:0] pp0 = b_ext[0] ? a_ext : 0;
    wire [2*size-1:0] pp1 = b_ext[1] ? (a_ext << 1) : 0;
    wire [2*size-1:0] pp2 = b_ext[2] ? (a_ext << 2) : 0;
    wire [2*size-1:0] pp3 = b_ext[3] ? (a_ext << 3) : 0;

    // Pipeline stage 1 registers
    reg [2*size-1:0] stage1_pp01_sum;
    reg [2*size-1:0] stage1_pp23_sum;

    // Pipeline stage 2 register
    reg [2*size-1:0] stage2_sum;

    // First pipeline stage: sum pp0+pp1 and pp2+pp3 separately
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage1_pp01_sum <= 0;
            stage1_pp23_sum <= 0;
        end else begin
            stage1_pp01_sum <= pp0 + pp1;
            stage1_pp23_sum <= pp2 + pp3;
        end
    end

    // Second pipeline stage: sum the intermediate results
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage2_sum <= 0;
            mul_out <= 0;
        end else begin
            stage2_sum <= stage1_pp01_sum + stage1_pp23_sum;
            mul_out <= stage2_sum;
        end
    end

endmodule