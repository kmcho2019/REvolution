module adder_pipe_64bit(
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output [64:0] result,
    output o_en
);

reg [63:0] adda_reg1, adda_reg2, adda_reg3;
reg [63:0] addb_reg1, addb_reg2, addb_reg3;
reg [64:0] sum_reg1, sum_reg2, sum_reg3;
reg i_en_reg1, i_en_reg2, i_en_reg3;
reg o_en_reg;

always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        adda_reg1 <= 64'd0;
        addb_reg1 <= 64'd0;
        i_en_reg1 <= 1'b0;
        adda_reg2 <= 64'd0;
        addb_reg2 <= 64'd0;
        i_en_reg2 <= 1'b0;
        adda_reg3 <= 64'd0;
        addb_reg3 <= 64'd0;
        i_en_reg3 <= 1'b0;
        sum_reg1 <= 65'd0;
        sum_reg2 <= 65'd0;
        sum_reg3 <= 65'd0;
        o_en_reg <= 1'b0;
    end else begin
        adda_reg1 <= adda;
        addb_reg1 <= addb;
        i_en_reg1 <= i_en;
        adda_reg2 <= adda_reg1;
        addb_reg2 <= addb_reg1;
        i_en_reg2 <= i_en_reg1;
        adda_reg3 <= adda_reg2;
        addb_reg3 <= addb_reg2;
        i_en_reg3 <= i_en_reg2;
        sum_reg1 <= {adda_reg1[63:0] + addb_reg1[63:0]};
        sum_reg2 <= {adda_reg2[63:0] + addb_reg2[63:0]};
        sum_reg3 <= {adda_reg3[63:0] + addb_reg3[63:0]};
        o_en_reg <= i_en_reg3;
    end
end

always @ (posedge clk) begin
    result <= sum_reg3;
    o_en <= o_en_reg;
end

endmodule