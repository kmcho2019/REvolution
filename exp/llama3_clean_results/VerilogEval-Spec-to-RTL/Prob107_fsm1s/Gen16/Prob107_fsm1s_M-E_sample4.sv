module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

reg [1:0] state; // Current state (2 states)
reg [1:0] nextState; // Next state
reg [0:0] nextOut; // Next output

// Look-Up Table (LUT) for next state and output
always @(*) begin
    case({state, in})
        2'b00: begin nextState = 2'b01; nextOut = 1'b0; end // State B, in = 0, next state A, out = 0
        2'b01: begin nextState = 2'b01; nextOut = 1'b0; end // State B, in = 1, next state B, out = 0
        2'b10: begin nextState = 2'b00; nextOut = 1'b1; end // State A, in = 0, next state B, out = 1
        2'b11: begin nextState = 2'b10; nextOut = 1'b0; end // State A, in = 1, next state A, out = 0
        default: begin nextState = 2'b00; nextOut = 1'b1; end // Default to state B, out = 1
    endcase
end

// State register
always @(posedge clk) begin
    if(reset) begin // Synchronous reset
        state <= 2'b00; // Reset to state B
        out <= 1'b1; // Reset output to 1
    end else begin
        state <= nextState; // Update state
        out <= nextOut; // Update output
    end
end

endmodule