module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

reg current_state;  // Declare the current state as a reg

// Sequential logic to update the current state
always @(posedge clk) begin
    if (reset) begin
        current_state <= 1'b1;  // Reset to state B
    end else begin
        case (current_state)
            1'b0: current_state <= (in == 1'b1)? 1'b0 : 1'b1;  // State A
            1'b1: current_state <= (in == 1'b0)? 1'b0 : 1'b1;  // State B
            default: current_state <= 1'b1;  // Default to state B
        endcase
    end
end

// Determine the output based on the current state
assign out = current_state;

endmodule