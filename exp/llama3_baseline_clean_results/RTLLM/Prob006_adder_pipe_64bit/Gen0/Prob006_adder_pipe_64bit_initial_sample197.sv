module adder_pipe_64bit(
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output reg [64:0] result,
    output reg o_en
);

reg [63:0] a_pipe1;
reg [63:0] b_pipe1;
reg i_en_pipe1;
reg [64:0] sum_pipe1;

reg [63:0] a_pipe2;
reg [63:0] b_pipe2;
reg i_en_pipe2;
reg [64:0] sum_pipe2;

reg [63:0] a_pipe3;
reg [63:0] b_pipe3;
reg i_en_pipe3;
reg [64:0] sum_pipe3;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        a_pipe1 <= 64'd0;
        b_pipe1 <= 64'd0;
        i_en_pipe1 <= 1'b0;
        sum_pipe1 <= 65'd0;
        a_pipe2 <= 64'd0;
        b_pipe2 <= 64'd0;
        i_en_pipe2 <= 1'b0;
        sum_pipe2 <= 65'd0;
        a_pipe3 <= 64'd0;
        b_pipe3 <= 64'd0;
        i_en_pipe3 <= 1'b0;
        sum_pipe3 <= 65'd0;
        o_en <= 1'b0;
    end else if (i_en) begin
        a_pipe1 <= adda;
        b_pipe1 <= addb;
        i_en_pipe1 <= i_en;
        sum_pipe1 <= adda + addb;
        a_pipe2 <= a_pipe1;
        b_pipe2 <= b_pipe1;
        i_en_pipe2 <= i_en_pipe1;
        sum_pipe2 <= sum_pipe1;
        a_pipe3 <= a_pipe2;
        b_pipe3 <= b_pipe2;
        i_en_pipe3 <= i_en_pipe2;
        sum_pipe3 <= sum_pipe2;
        o_en <= i_en_pipe3;
    end else begin
        a_pipe1 <= a_pipe1;
        b_pipe1 <= b_pipe1;
        i_en_pipe1 <= i_en_pipe1;
        sum_pipe1 <= sum_pipe1;
        a_pipe2 <= a_pipe2;
        b_pipe2 <= b_pipe2;
        i_en_pipe2 <= i_en_pipe2;
        sum_pipe2 <= sum_pipe2;
        a_pipe3 <= a_pipe3;
        b_pipe3 <= b_pipe3;
        i_en_pipe3 <= i_en_pipe3;
        sum_pipe3 <= sum_pipe3;
        o_en <= i_en_pipe3;
    end
end

always @(*) begin
    result = sum_pipe3;
end

endmodule