module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

reg state; // 1-bit register to hold the state
wire next_state; // combinational signal for next state

// Combinational logic for next state
assign next_state = (state == 1'b0) ? (in == 1'b0) ? 1'b1 : 1'b0 : (in == 1'b0) ? 1'b0 : 1'b1;

// Output is directly the current state
assign out = state;

// Sequential logic for state update
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 1'b1; // Reset state to B (1) on async reset
    end else begin
        state <= next_state; // Update state on clock edge
    end
end

endmodule