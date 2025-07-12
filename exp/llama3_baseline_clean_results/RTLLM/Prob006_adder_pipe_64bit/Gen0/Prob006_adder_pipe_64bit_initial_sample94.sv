module adder_pipe_64bit (
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output [64:0] result,
    output o_en
);

reg [63:0] adda_pipe1;
reg [63:0] addb_pipe1;
reg i_en_pipe1;
reg [63:0] adda_pipe2;
reg [63:0] addb_pipe2;
reg i_en_pipe2;
reg [63:0] adda_pipe3;
reg [63:0] addb_pipe3;
reg i_en_pipe3;
reg [64:0] sum;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        adda_pipe1 <= 64'd0;
        addb_pipe1 <= 64'd0;
        i_en_pipe1 <= 1'b0;
        adda_pipe2 <= 64'd0;
        addb_pipe2 <= 64'd0;
        i_en_pipe2 <= 1'b0;
        adda_pipe3 <= 64'd0;
        addb_pipe3 <= 64'd0;
        i_en_pipe3 <= 1'b0;
        sum <= 65'd0;
        result <= 65'd0;
        o_en <= 1'b0;
    end else begin
        adda_pipe1 <= adda;
        addb_pipe1 <= addb;
        i_en_pipe1 <= i_en;
        adda_pipe2 <= adda_pipe1;
        addb_pipe2 <= addb_pipe1;
        i_en_pipe2 <= i_en_pipe1;
        adda_pipe3 <= adda_pipe2;
        addb_pipe3 <= addb_pipe2;
        i_en_pipe3 <= i_en_pipe2;
        if (i_en_pipe3) begin
            sum <= adda_pipe3 + addb_pipe3;
        end else begin
            sum <= 65'd0;
        end
        result <= sum;
        o_en <= i_en_pipe3;
    end
end

endmodule