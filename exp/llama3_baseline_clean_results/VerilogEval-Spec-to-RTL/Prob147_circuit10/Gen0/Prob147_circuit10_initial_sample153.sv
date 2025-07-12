module TopModule(
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg;
reg q_reg;

assign state = state_reg;
assign q = q_reg;

always @(posedge clk) begin
    state_reg <= (a == 0 && b == 0 && (state_reg == 1 || q_reg == 1)) ? 1 : state_reg;
    q_reg <= (a == 0 && b == 1) ? 1 : 
             (a == 1 && b == 0 && state_reg == 0) ? 0 : 
             (a == 1 && b == 1 && state_reg == 0) ? 0 : q_reg;
end

endmodule