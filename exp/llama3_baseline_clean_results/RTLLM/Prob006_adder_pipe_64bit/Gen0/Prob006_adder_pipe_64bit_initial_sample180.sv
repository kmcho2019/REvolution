module adder_pipe_64bit(
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output [64:0] result,
    output o_en
);

reg [63:0] adda_reg;
reg [63:0] addb_reg;
reg i_en_reg;
reg i_en_reg2;
reg [63:0] sum;
reg [63:0] carry;
reg [64:0] result_reg;
reg o_en_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        adda_reg <= 64'd0;
        addb_reg <= 64'd0;
        i_en_reg <= 1'd0;
        i_en_reg2 <= 1'd0;
    end else if (i_en) begin
        adda_reg <= adda;
        addb_reg <= addb;
        i_en_reg <= 1'd1;
    end else begin
        adda_reg <= adda_reg;
        addb_reg <= addb_reg;
        i_en_reg <= 1'd0;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        i_en_reg2 <= 1'd0;
    end else begin
        i_en_reg2 <= i_en_reg;
    end
end

always @(*) begin
    carry = 1'd0;
    sum = adda_reg + addb_reg + carry;
    result_reg = {1'd0, sum};
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        result <= 65'd0;
        o_en_reg <= 1'd0;
    end else if (i_en_reg2) begin
        result <= result_reg;
        o_en_reg <= 1'd1;
    end else begin
        result <= result;
        o_en_reg <= 1'd0;
    end
end

assign result = result;
assign o_en = o_en_reg;

endmodule