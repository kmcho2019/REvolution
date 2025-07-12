module TopModule (
    input clk,
    input d,
    output q
);

wire q_next;
reg q_reg;

assign q_next = clk ? d : q_reg;
assign q = q_reg;

always @(posedge clk or negedge clk) begin
    q_reg <= q_next;
end

endmodule