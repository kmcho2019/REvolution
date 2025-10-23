module adder_pipe_64bit (
    input           clk,
    input           rst_n,
    input           i_en,
    input   [63:0]  adda,
    input   [63:0]  addb,
    output  [64:0]  result,
    output          o_en
);

reg [63:0] adda_reg;
reg [63:0] addb_reg;
reg [64:0] result_reg;
reg o_en_reg;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        adda_reg <= 64'd0;
        addb_reg <= 64'd0;
        o_en_reg <= 1'b0;
    end else if (i_en) begin
        adda_reg <= adda;
        addb_reg <= addb;
        o_en_reg <= 1'b0;
    end
end

reg [7:0] carries [7:0];
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        carries <= {8{8'd0}};
    end else begin
        carries[0] <= (adda_reg[7:0] + addb_reg[7:0]) > 8'd255 ? 1'b1 : 1'b0;
        for (int i = 1; i < 8; i++) begin
            carries[i] <= (adda_reg[(i*8)+7:(i*8)] + addb_reg[(i*8)+7:(i*8)] + (carries[i-1] ? 1'b1 : 1'b0)) > 8'd255 ? 1'b1 : 1'b0;
        end
    end
end

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        result_reg <= 65'd0;
        o_en_reg <= 1'b0;
    end else begin
        result_reg <= {carries[7], (adda_reg + addb_reg)};
        if (i_en) begin
            o_en_reg <= 1'b1;
        end else begin
            o_en_reg <= 1'b0;
        end
    end
end

assign result = result_reg;
assign o_en = o_en_reg;

endmodule