module adder_pipe_64bit(
    input           clk,
    input           rst_n,
    input           i_en,
    input   [63:0]  adda,
    input   [63:0]  addb,
    output  [64:0]  result,
    output          o_en
);

reg [63:0] adda_pipe1;
reg [63:0] addb_pipe1;
reg        i_en_pipe1;
reg [63:0] adda_pipe2;
reg [63:0] addb_pipe2;
reg        i_en_pipe2;
reg [63:0] sum_pipe2;
reg        carry_pipe2;
reg [64:0] result_pipe3;
reg        o_en_pipe3;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        adda_pipe1 <= 64'd0;
        addb_pipe1 <= 64'd0;
        i_en_pipe1 <= 1'b0;
    end else if (i_en) begin
        adda_pipe1 <= adda;
        addb_pipe1 <= addb;
        i_en_pipe1 <= i_en;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        adda_pipe2 <= 64'd0;
        addb_pipe2 <= 64'd0;
        i_en_pipe2 <= 1'b0;
    end else begin
        adda_pipe2 <= adda_pipe1;
        addb_pipe2 <= addb_pipe1;
        i_en_pipe2 <= i_en_pipe1;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        sum_pipe2 <= 64'd0;
        carry_pipe2 <= 1'b0;
    end else if (i_en_pipe2) begin
        {carry_pipe2, sum_pipe2} <= adda_pipe2 + addb_pipe2;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        result_pipe3 <= 65'd0;
        o_en_pipe3 <= 1'b0;
    end else if (i_en_pipe2) begin
        result_pipe3 <= {1'b0, sum_pipe2} + {64'd0, carry_pipe2};
        o_en_pipe3 <= 1'b1;
    end else begin
        o_en_pipe3 <= 1'b0;
    end
end

assign result = result_pipe3;
assign o_en = o_en_pipe3;

endmodule