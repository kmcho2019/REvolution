module adder_pipe_64bit(
    input clk,
    input rst_n,
    input i_en,
    input [63:0] adda,
    input [63:0] addb,
    output [64:0] result,
    output o_en
);

reg [63:0] adda_reg1, adda_reg2, adda_reg3, adda_reg4;
reg [63:0] addb_reg1, addb_reg2, addb_reg3, addb_reg4;
reg [64:0] sum_reg1, sum_reg2, sum_reg3, sum_reg4;
reg i_en_reg1, i_en_reg2, i_en_reg3, i_en_reg4, o_en_reg;

always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        adda_reg1 <= 64'd0;
        adda_reg2 <= 64'd0;
        adda_reg3 <= 64'd0;
        adda_reg4 <= 64'd0;
        addb_reg1 <= 64'd0;
        addb_reg2 <= 64'd0;
        addb_reg3 <= 64'd0;
        addb_reg4 <= 64'd0;
        sum_reg1 <= 65'd0;
        sum_reg2 <= 65'd0;
        sum_reg3 <= 65'd0;
        sum_reg4 <= 65'd0;
        i_en_reg1 <= 1'b0;
        i_en_reg2 <= 1'b0;
        i_en_reg3 <= 1'b0;
        i_en_reg4 <= 1'b0;
        o_en_reg <= 1'b0;
    end else begin
        adda_reg1 <= adda;
        adda_reg2 <= adda_reg1;
        adda_reg3 <= adda_reg2;
        adda_reg4 <= adda_reg3;
        
        addb_reg1 <= addb;
        addb_reg2 <= addb_reg1;
        addb_reg3 <= addb_reg2;
        addb_reg4 <= addb_reg3;
        
        i_en_reg1 <= i_en;
        i_en_reg2 <= i_en_reg1;
        i_en_reg3 <= i_en_reg2;
        i_en_reg4 <= i_en_reg3;
        
        sum_reg1 <= {1'b0, adda_reg1} + {1'b0, addb_reg1};
        sum_reg2 <= sum_reg1;
        sum_reg3 <= sum_reg2;
        sum_reg4 <= sum_reg3;
        
        o_en_reg <= i_en_reg4;
    end
end

assign result = sum_reg4;
assign o_en = o_en_reg;

endmodule