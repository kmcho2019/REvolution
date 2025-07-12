module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

reg [0:0] state; // 1-bit register to store the current state
reg [0:0] next_state; // 1-bit register to store the next state

// Asynchronous reset
always @(posedge areset or posedge clk) begin
    if(areset) begin
        state <= 1'b1; // Reset to state B
    end else begin
        state <= next_state;
    end
end

// Determine the next state and output
always @(*) begin
    case(state)
        1'b0: begin // State A
            if(in) begin
                next_state = 1'b0; // Stay in state A
            end else begin
                next_state = 1'b1; // Transition to state B
            end
            out = 1'b0; // Output in state A
        end
        1'b1: begin // State B
            if(in) begin
                next_state = 1'b1; // Stay in state B
            end else begin
                next_state = 1'b0; // Transition to state A
            end
            out = 1'b1; // Output in state B
        end
        default: begin
            next_state = 1'b1; // Default to state B
            out = 1'b1; // Default output
        end
    endcase
end

endmodule