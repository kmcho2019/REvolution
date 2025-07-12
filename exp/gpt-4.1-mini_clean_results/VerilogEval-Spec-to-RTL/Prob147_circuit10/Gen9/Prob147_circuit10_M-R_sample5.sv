module TopModule(
    input clk,
    input a,
    input b,
    output state,
    output q
);

reg state_reg;

wire next_state;
wire q_wire;

assign next_state = (state_reg & ~(a & b)) | (~state_reg & ~a & b);
assign q_wire = state_reg ^ (a & b);

always @(posedge clk) begin
    state_reg <= next_state;
end

assign state = state_reg;
assign q = q_wire;

initial begin
    state_reg = 1'b0;
end

endmodule