module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

reg [1:0] current_state; // Using 2 bits to encode the state for PLA implementation

// PLA Implementation
always_ff @(posedge clk) begin
    if (reset) begin
        current_state <= 2'b00; // Reset to OFF state
    end else begin
        case (current_state)
            2'b00: current_state <= j? 2'b01 : 2'b00; // Transition to ON if j is 1, otherwise stay in OFF
            2'b01: current_state <= ~k? 2'b01 : 2'b00; // Stay in ON state if k is 0, otherwise transition to OFF
            default: current_state <= 2'b00; // Default case to ensure no illegal states
        endcase
    end
end

// Output Logic
assign out = current_state[0]; // Output is directly dependent on the state

endmodule