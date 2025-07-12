module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output [3:0] q
);

reg [3:0] stage1_reg;
reg [3:0] q_reg;

always @(posedge clk) begin
    if (shift_ena) begin
        stage1_reg <= {data, stage1_reg[3:1]};
    end else begin
        stage1_reg <= stage1_reg;
    end
end

always @(posedge clk) begin
    if (count_ena) begin
        if (stage1_reg == 4'b0000) begin
            q_reg <= 4'b1111;
        end else begin
            q_reg <= stage1_reg - 1;
        end
    end else if (shift_ena) begin
        q_reg <= stage1_reg;
    end else begin
        q_reg <= q_reg;
    end
end

assign q = q_reg;

endmodule