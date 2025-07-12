module TopModule(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output [3:0] q
);

reg [3:0] q_reg = 4'b0;
reg [3:0] temp_reg = 4'b0;

always @(posedge clk) begin
    if (shift_ena) begin
        temp_reg <= {data, q_reg[3:1]};
    end else if (count_ena) begin
        if (q_reg!= 4'b0) begin
            temp_reg <= q_reg - 1;
        end else begin
            temp_reg <= q_reg;
        end
    end else begin
        temp_reg <= q_reg;
    end
end

always @(posedge clk) begin
    q_reg <= temp_reg;
end

assign q = q_reg;

endmodule