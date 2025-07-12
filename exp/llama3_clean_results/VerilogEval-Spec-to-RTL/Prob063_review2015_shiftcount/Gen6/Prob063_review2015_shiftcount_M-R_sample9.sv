module TopModule(
    input clk,
    input shift_ena,
    input count_ena,
    input data,
    output [3:0] q
);

reg [3:0] q_reg = 0; // Initialize q_reg to 0

wire shift_out;
assign shift_out = {data, q_reg[3:1]};

wire count_out;
assign count_out = (q_reg == 0) ? q_reg : q_reg - 1;

reg [3:0] next_q;
always @(posedge clk) begin
    if (shift_ena) begin
        next_q <= shift_out;
    end else if (count_ena) begin
        next_q <= count_out;
    end else begin
        next_q <= q_reg;
    end
end

assign q_reg = next_q;
assign q = q_reg;

endmodule