module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

reg current_state;  // Declare the current state as a reg
reg next_state;     // Declare the next state as a reg

// Combinational logic to determine the next state
always @(*) begin
    case (current_state)
        1'b0: next_state = (in == 1'b1) ? 1'b0 : 1'b1;  // State A
        1'b1: next_state = (in == 1'b0) ? 1'b0 : 1'b1;  // State B
        default: next_state = 1'b1;  // Default to state B
    endcase
end

// Sequential logic to update the current state
always @(posedge clk) begin
    if (reset) begin
        current_state <= 1'b1;  // Reset to state B
    end else begin
        current_state <= next_state;
    end
end

// Determine the output based on the current state
assign out = (current_state == 1'b1) ? 1'b1 : 1'b0;

endmodule