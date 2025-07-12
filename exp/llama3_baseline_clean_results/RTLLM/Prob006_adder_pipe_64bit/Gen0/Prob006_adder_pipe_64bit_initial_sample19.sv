module adder_pipe_64bit(
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output [64:0] result,
    output o_en
);

// Define the pipeline stages
reg [63:0] stage1_a;
reg [63:0] stage1_b;
reg [63:0] stage2_a;
reg [63:0] stage2_b;
reg [64:0] stage3_result;

// Define the carry signals
reg [63:0] carry;

// Define the output enable signal
reg o_en_reg;

// Initialize the output enable signal
initial o_en_reg = 1'b0;

// Define the full adder
function [64:0] full_adder;
    input [63:0] a;
    input [63:0] b;
    input c_in;
    begin
        full_adder = {1'b0, a} + {1'b0, b} + {63'b0, c_in};
    end
endfunction

// Define the always block for the pipeline stages
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage1_a <= 64'd0;
        stage1_b <= 64'd0;
        stage2_a <= 64'd0;
        stage2_b <= 64'd0;
        stage3_result <= 65'd0;
        o_en_reg <= 1'b0;
    end else if (i_en) begin
        stage1_a <= adda;
        stage1_b <= addb;
        stage2_a <= adda;
        stage2_b <= addb;
        stage3_result <= full_adder(stage1_a, stage1_b, 1'b0);
        o_en_reg <= 1'b1;
    end else if (o_en_reg) begin
        stage1_a <= 64'd0;
        stage1_b <= 64'd0;
        stage2_a <= 64'd0;
        stage2_b <= 64'd0;
        stage3_result <= 65'd0;
        o_en_reg <= 1'b0;
    end else begin
        stage1_a <= stage1_a;
        stage1_b <= stage1_b;
        stage2_a <= stage2_a;
        stage2_b <= stage2_b;
        stage3_result <= stage3_result;
        o_en_reg <= o_en_reg;
    end
end

// Assign the output signals
assign result = stage3_result;
assign o_en = o_en_reg;

endmodule