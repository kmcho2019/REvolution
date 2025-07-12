module adder_pipe_64bit (
    input           clk,
    input           rst_n,
    input           i_en,
    input   [63:0]  adda,
    input   [63:0]  addb,
    output  [64:0]  result,
    output          o_en
);

reg [63:0]  adda_reg1, adda_reg2, adda_reg3;
reg [63:0]  addb_reg1, addb_reg2, addb_reg3;
reg         i_en_reg1, i_en_reg2, i_en_reg3;
reg [64:0]  sum_reg1, sum_reg2, sum_reg3;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        adda_reg1 <= 64'd0;
        addb_reg1 <= 64'd0;
        i_en_reg1 <= 1'b0;
        sum_reg1 <= 65'd0;
    end else if (i_en) begin
        adda_reg1 <= adda;
        addb_reg1 <= addb;
        i_en_reg1 <= 1'b1;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        adda_reg2 <= 64'd0;
        addb_reg2 <= 64'd0;
        i_en_reg2 <= 1'b0;
        sum_reg1 <= 65'd0;
    end else if (i_en_reg1) begin
        adda_reg2 <= adda_reg1;
        addb_reg2 <= addb_reg1;
        i_en_reg2 <= 1'b1;
        sum_reg1 <= {1'b0, adda_reg1} + {1'b0, addb_reg1};
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        adda_reg3 <= 64'd0;
        addb_reg3 <= 64'd0;
        i_en_reg3 <= 1'b0;
        sum_reg2 <= 65'd0;
    end else if (i_en_reg2) begin
        adda_reg3 <= adda_reg2;
        addb_reg3 <= addb_reg2;
        i_en_reg3 <= 1'b1;
        sum_reg2 <= sum_reg1;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        result <= 65'd0;
        o_en <= 1'b0;
        sum_reg3 <= 65'd0;
    end else if (i_en_reg3) begin
        result <= sum_reg2;
        o_en <= 1'b1;
        sum_reg3 <= sum_reg2;
    end else begin
        o_en <= 1'b0;
    end
end

endmodule