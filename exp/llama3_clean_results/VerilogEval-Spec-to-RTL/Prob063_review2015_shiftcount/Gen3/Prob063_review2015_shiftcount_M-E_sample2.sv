module TopModule(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output [3:0] q
);

reg [3:0] q_reg;
reg [3:0] next_q;

always @(*) begin
    next_q = q_reg;
    if (shift_ena) begin
        next_q = {data, q_reg[3:1]};
    end else if (count_ena) begin
        if (q_reg > 0) begin
            next_q = q_reg - 1;
        end else begin
            next_q = 0;
        end
    end
end

always @(posedge clk) begin
    q_reg <= next_q;
end

assign q = q_reg;

endmodule