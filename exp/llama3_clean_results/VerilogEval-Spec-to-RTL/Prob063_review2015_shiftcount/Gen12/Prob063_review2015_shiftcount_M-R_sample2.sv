module TopModule(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output [3:0] q
);

reg [3:0] q_reg = 0;
wire [3:0] shift_next;
wire [3:0] count_next;

assign shift_next = {data, q_reg[3:1]};
assign count_next = (q_reg == 0) ? 0 : q_reg - 1;

always @(posedge clk) begin
    if (shift_ena) begin
        q_reg <= shift_next;
    end else if (count_ena) begin
        q_reg <= count_next;
    end else begin
        q_reg <= q_reg;
    end
end

assign q = q_reg;

endmodule