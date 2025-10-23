module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

reg state; // 1-bit variable to hold the state (0 or 1)

// Initialize the state to 1 (state B) to ensure a defined starting point
initial state = 1'b1;

// Directly assign the output based on the current state
assign out = (state == 1'b1)? 1'b1 : 1'b0;

// Sequential logic for state transitions
always @(posedge clk) begin
    if(reset) begin // Synchronous reset
        state <= 1'b1; // Reset to state B
    end else begin
        // Simplified state transition logic
        case ({state, in})
            2'b00: state <= 1'b1; // A, in=0 -> B
            2'b01: state <= 1'b0; // A, in=1 -> A
            2'b10: state <= 1'b0; // B, in=0 -> A
            2'b11: state <= 1'b1; // B, in=1 -> B
        endcase
    end
end

endmodule