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

    // Pipeline registers
    reg [2*size-1:0] stage1_sum;  // sum of pp[0] and pp[1]
    reg [2*size-1:0] stage1_pp2;  // registered pp[2]

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            stage1_sum <= 0;
            stage1_pp2 <= 0;
            mul_out <= 0;
        end else begin
            // First pipeline stage
            stage1_sum <= (mul_b[0] ? a_ext : 0) + (mul_b[1] ? (a_ext << 1) : 0);
            stage1_pp2 <= mul_b[2] ? (a_ext << 2) : 0;
            
            // Second pipeline stage (combines previous stage2_sum + pp3)
            mul_out <= stage1_sum + stage1_pp2 + (mul_b[3] ? (a_ext << 3) : 0);
        end
    end

endmodule