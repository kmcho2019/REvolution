module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

reg state; // Using 1 bit for state

// Simplified combinational logic for next state
always @(*) begin
    case(state)
        1'b0: next_state = j;
        1'b1: next_state = ~k;
        default: next_state = 1'b0;
    endcase
end

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