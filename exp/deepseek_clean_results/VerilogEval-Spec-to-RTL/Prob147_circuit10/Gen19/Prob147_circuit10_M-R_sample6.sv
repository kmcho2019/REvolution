module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg = 0;

// State transition logic using continuous assignment
wire next_state = (a & b) ? 1'b1 : 
                 (~a & ~b) ? 1'b0 : 
                 state_reg;

always @(posedge clk) begin
    state_reg <= next_state;
end

// Output logic - optimized XOR/XNOR selection
assign q = state_reg ? ~(a ^ b) : (a ^ b);
assign state = state_reg;

endmodule