module multi_pipe_4bit #(
    parameter size = 4  // Explicit parameter declaration
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

    // Partial products (optimized generation)
    wire [2*size-1:0] pp0 = b_ext[0] ? a_ext : 0;
    wire [2*size-1:0] pp1 = b_ext[1] ? (a_ext << 1) : 0;
    wire [2*size-1:0] pp2 = b_ext[2] ? (a_ext << 2) : 0;
    wire [2*size-1:0] pp3 = b_ext[3] ? (a_ext << 3) : 0;

    // Pipeline registers
    reg [2*size-1:0] stage0_reg;  // First stage register
    reg [2*size-1:0] stage1_reg;  // Second stage register

    // Pipeline stage computations
    wire [2*size-1:0] stage0_sum = pp0 + pp1;  // First stage adds 2 terms
    wire [2*size-1:0] stage1_sum = stage0_reg + pp2 + pp3;  // Second stage adds remaining terms

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            stage0_reg <= 0;
            stage1_reg <= 0;
            mul_out <= 0;
        end else begin
            // First pipeline stage
            stage0_reg <= stage0_sum;
            
            // Second pipeline stage
            stage1_reg <= stage1_sum;
            
            // Final output (registered)
            mul_out <= stage1_reg;
        end
    end

endmodule