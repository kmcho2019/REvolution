module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg = 1'b0;

// Sequential logic for state
always @(posedge clk) begin
    state_reg <= (a ^ b) ? ~state_reg : state_reg;
end

// Combinational logic for outputs
assign state = state_reg;
assign q = (a == b) ? state_reg : ~state_reg;

endmodule