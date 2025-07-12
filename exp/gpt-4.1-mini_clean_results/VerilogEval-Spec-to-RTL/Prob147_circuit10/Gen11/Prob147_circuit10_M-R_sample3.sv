module TopModule (
    input  clk,
    input  a,
    input  b,
    output state,
    output q
);

reg state_reg;
wire next_state;
wire q_wire;

assign next_state = b ? ~a : state_reg;
assign q_wire = b ? a : state_reg;

always @(posedge clk) begin
    state_reg <= next_state;
end

assign state = state_reg;
assign q = q_wire;

endmodule