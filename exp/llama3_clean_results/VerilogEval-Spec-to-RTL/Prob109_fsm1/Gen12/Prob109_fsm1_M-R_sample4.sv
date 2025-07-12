module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

reg state; // 1-bit register to hold the state

// Combinational logic for next state
wire next_state;
assign next_state = (state == 1'b0) ? (in ? 1'b0 : 1'b1) : (in ? 1'b1 : 1'b0);

// Output assignment
assign out = state;

// Sequential logic for state update
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 1'b1; // asynchronous reset to state B
    end else begin
        state <= next_state; // update state based on next_state
    end
end

endmodule