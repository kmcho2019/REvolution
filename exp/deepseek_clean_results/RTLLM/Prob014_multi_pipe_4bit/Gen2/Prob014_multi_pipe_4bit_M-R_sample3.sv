module multi_pipe_4bit #(parameter size = 4) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

    // Extended inputs with zeros at MSB
    wire [2*size-1:0] a_ext = {{size{1'b0}}, mul_a};
    wire [2*size-1:0] b_ext = {{size{1'b0}}, mul_b};

    // Partial products calculation
    wire [2*size-1:0] pp0 = b_ext[0] ? a_ext : 0;
    wire [2*size-1:0] pp1 = b_ext[1] ? (a_ext << 1) : 0;
    wire [2*size-1:0] pp2 = b_ext[2] ? (a_ext << 2) : 0;
    wire [2*size-1:0] pp3 = b_ext[3] ? (a_ext << 3) : 0;

    // Pipeline stage 1 registers
    reg [2*size-1:0] stage1_sum01;
    reg [2*size-1:0] stage1_pp2;
    reg [2*size-1:0] stage1_pp3;

    // Pipeline stage 2 registers
    reg [2*size-1:0] stage2_sum;

    // Stage 1: Register partial products and first sum
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage1_sum01 <= 0;
            stage1_pp2 <= 0;
            stage1_pp3 <= 0;
        end else begin
            stage1_sum01 <= pp0 + pp1;
            stage1_pp2 <= pp2;
            stage1_pp3 <= pp3;
        end
    end

    // Stage 2: Final accumulation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage2_sum <= 0;
            mul_out <= 0;
        end else begin
            stage2_sum <= stage1_sum01 + stage1_pp2;
            mul_out <= stage2_sum + stage1_pp3;
        end
    end

endmodule