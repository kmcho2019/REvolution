module adder_pipe_64bit(
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output [64:0] result,
    output o_en
);

reg [63:0] reg_adda;
reg [63:0] reg_addb;
reg [63:0] sum;
reg [63:0] carry;
reg en_pipe1, en_pipe2, en_pipe3, o_en_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        reg_adda <= 64'd0;
        reg_addb <= 64'd0;
        en_pipe1 <= 1'b0;
        en_pipe2 <= 1'b0;
        en_pipe3 <= 1'b0;
        o_en_reg <= 1'b0;
    end else begin
        reg_adda <= adda;
        reg_addb <= addb;
        en_pipe1 <= i_en;
        en_pipe2 <= en_pipe1;
        en_pipe3 <= en_pipe2;
        o_en_reg <= en_pipe3;
    end
end

assign result = {1'b0, reg_adda} + {1'b0, reg_addb};

assign o_en = o_en_reg;

endmodule