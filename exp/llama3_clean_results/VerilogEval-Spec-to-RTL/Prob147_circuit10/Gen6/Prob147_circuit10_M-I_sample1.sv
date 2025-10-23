module TopModule(
    input  clk,
    input  a,
    input  b,
    output q,
    output state
);

reg state_reg; // Flip-flop to hold the state
assign state = state_reg; // Make state observable

// Sequential logic to update the state
always @(posedge clk) begin
    if (~a && b) begin // Set state to 1 when a=0 and b=1
        state_reg <= 1'b1;
    end else if (a && ~b) begin // Reset state to 0 when a=1 and b=0
        state_reg <= 1'b0;
    end else begin // Maintain current state under other conditions
        state_reg <= state_reg;
    end
end

// Combinational logic to generate output q
assign q = (b) || (a && state_reg); // q is high when b=1 or (a=1 and state=1)

endmodule