module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

reg state; // Using 1 bit for state

// Combinational logic for next state
wire next_state;
assign next_state = (state == 1'b0) ? j : (state == 1'b1) ? ~k : 1'b0;

// Sequential logic for state update
always @(posedge clk) begin
    if (reset) begin
        state <= 1'b0; // Reset to OFF state
    end else begin
        state <= next_state;
    end
end

// Output is determined by the current state
assign out = state;

endmodule