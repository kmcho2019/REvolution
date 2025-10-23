module multi_pipe_4bit #(
    parameter size = 4
) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

    // Extended versions of inputs (zero-padded)
    wire [2*size-1:0] ext_a = {{size{1'b0}}, mul_a};
    wire [2*size-1:0] ext_b = {{size{1'b0}}, mul_b};

    // Pipeline stage 1 registers (partial products)
    reg [2*size-1:0] pp0, pp1, pp2, pp3;
    // Pipeline stage 2 register (accumulation)
    reg [2*size-1:0] sum_stage1;

    // Generate partial products
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            pp0 <= 0;
            pp1 <= 0;
            pp2 <= 0;
            pp3 <= 0;
        end else begin
            pp0 <= ext_b[0] ? ext_a       : 0;
            pp1 <= ext_b[1] ? ext_a << 1  : 0;
            pp2 <= ext_b[2] ? ext_a << 2  : 0;
            pp3 <= ext_b[3] ? ext_a << 3  : 0;
        end
    end

    // Accumulate partial products
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_stage1 <= 0;
        end else begin
            sum_stage1 <= pp0 + pp1 + pp2 + pp3;
        end
    end

    // Final output
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mul_out <= 0;
        end else begin
            mul_out <= sum_stage1;
        end
    end

endmodule