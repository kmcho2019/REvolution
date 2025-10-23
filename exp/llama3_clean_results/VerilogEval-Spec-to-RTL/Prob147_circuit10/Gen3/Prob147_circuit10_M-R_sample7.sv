module TopModule(
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg;  // internal register to store the state
assign state = state_reg;

wire next_state;  // wire to define the next state
assign next_state = (a == 1'b0 && b == 1'b1)? 1'b1 :
                    (a == 1'b1 && b == 1'b1)? 1'b0 :
                    state_reg;  // In all other cases, state remains the same

always @(posedge clk) begin
    state_reg <= next_state;
end

assign q = (state_reg == 1'b1 && b == 1'b1) || (a == 1'b1 && b == 1'b0);

endmodule