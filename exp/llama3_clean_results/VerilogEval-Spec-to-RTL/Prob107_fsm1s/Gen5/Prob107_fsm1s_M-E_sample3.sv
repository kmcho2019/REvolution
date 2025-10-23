module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

reg [1:0] state; // 2-bit variable to hold the state (0 or 1)
reg [1:0] nextState; // 2-bit variable to hold the next state
reg [0:0] nextOut; // 1-bit variable to hold the next output

// Lookup table for next state and output
always @(*) begin
    case({state, in})
        2'b00: begin // State A, in = 0
            nextState = 2'b01; // Transition to state B
            nextOut = 1'b1;
        end
        2'b01: begin // State A, in = 1
            nextState = 2'b00; // Stay in state A
            nextOut = 1'b0;
        end
        2'b10: begin // State B, in = 0
            nextState = 2'b00; // Transition to state A
            nextOut = 1'b0;
        end
        2'b11: begin // State B, in = 1
            nextState = 2'b10; // Stay in state B
            nextOut = 1'b1;
        end
    endcase
end

// Sequential logic for state transitions and output assignment
always @(posedge clk) begin
    if(reset) begin // Synchronous reset
        state <= 2'b10; // Reset to state B
        out <= 1'b1;
    end else begin
        state <= nextState;
        out <= nextOut;
    end
end

endmodule