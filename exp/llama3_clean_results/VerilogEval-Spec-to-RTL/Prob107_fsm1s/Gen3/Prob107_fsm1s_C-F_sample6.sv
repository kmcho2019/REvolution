module TopModule (
    input clk,
    input reset,
    input in,
    output reg out
);

// Define states explicitly
localparam STATE_B = 1'b1;  // State B represented by binary '1'
localparam STATE_A = 1'b0;  // State A represented by binary '0'

reg current_state;  // Use a 1-bit register to represent the current state

// Sequential logic to update the current state
always @(posedge clk) begin
    if (reset) begin
        current_state <= STATE_B;  // Reset to state B
    end else begin
        case ({current_state, in})
            2'b00: current_state <= STATE_A;  // State B with in=0, go to state A
            2'b01: current_state <= STATE_B;  // State B with in=1, stay in state B
            2'b10: current_state <= STATE_B;  // State A with in=0, go to state B
            2'b11: current_state <= STATE_A;  // State A with in=1, stay in state A
        endcase
    end
end

// Determine the output based on the current state
assign out = current_state;  // Output is 1 in state B and 0 in state A

endmodule