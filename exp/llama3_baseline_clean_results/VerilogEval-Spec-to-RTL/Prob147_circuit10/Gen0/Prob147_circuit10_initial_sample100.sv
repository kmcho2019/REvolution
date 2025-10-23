module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output state
);

reg state_reg; // Register to store the state
assign state = state_reg; // Continuous assignment to output state

// Combinational logic for next state and output q
always @(a, b, state_reg) begin
    if ((a == 1'b1 && b == 1'b0) || (a == 1'b0 && b == 1'b1) || (state_reg == 1'b0 && a == 1'b1 && b == 1'b1)) begin
        q = ~state_reg; // q is inverse of state when a and b are different, or when state is 0 and a and b are both 1
    end else begin
        q = state_reg; // q is equal to state when a and b are the same
    end
end

// D-type flip-flop
always @(posedge clk) begin
    if ((a == 1'b1 && b == 1'b0) || (a == 1'b0 && b == 1'b1) || (state_reg == 1'b0 && a == 1'b1 && b == 1'b1)) begin
        state_reg <= ~state_reg; // Flip the state when a and b are different, or when state is 0 and a and b are both 1
    end else begin
        state_reg <= state_reg; // Keep state the same when a and b are the same
    end
end

endmodule