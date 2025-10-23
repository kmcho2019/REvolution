module adder_pipe_64bit(
    input           clk,
    input           rst_n,
    input           i_en,
    input   [63:0]  adda,
    input   [63:0]  addb,
    output  [64:0]  result,
    output          o_en
);

reg [7:0] segment_regs [7:0];
reg [7:0] adda_regs [7:0];
reg [7:0] addb_regs [7:0];
reg [64:0] result_reg;
reg o_en_reg;

always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        for (int i = 0; i < 8; i++) begin
            adda_regs[i] <= 8'd0;
            addb_regs[i] <= 8'd0;
            segment_regs[i] <= 8'd0;
        end
        result_reg <= 65'd0;
        o_en_reg <= 1'b0;
    end else if (i_en) begin
        for (int i = 0; i < 8; i++) begin
            adda_regs[i] <= adda[(i*8)+:8];
            addb_regs[i] <= addb[(i*8)+:8];
        end
        o_en_reg <= 1'b0;
    end else begin
        result_reg <= 65'd0;
        for (int i = 0; i < 8; i++) begin
            if (i == 0) begin
                result_reg[7:0] <= adda_regs[i] + addb_regs[i];
            end else begin
                result_reg[(i*8)+7:(i*8)] <= adda_regs[i] + addb_regs[i] + (result_reg[(i-1)*8+7] >> 7);
            end
            if (i == 7) begin
                result_reg[64] <= (result_reg[(i-1)*8+7] >> 7);
            end
        end
        o_en_reg <= 1'b1;
    end
end

assign result = result_reg;
assign o_en = o_en_reg;

endmodule