module TopModule(
    input           clk,
    input           areset,
    input           train_valid,
    input           train_taken,
    output reg [1:0] state
);

reg [1:0] nextState;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01; // Reset to state 1 (weakly not-taken)
    end else begin
        case (state)
            2'b00: begin // State 0
                if (train_valid && train_taken) begin
                    state <= 2'b01; // Increment to state 1
                end else if (train_valid && !train_taken) begin
                    state <= 2'b00; // Stay in state 0
                end else begin
                    state <= 2'b00; // Stay in state 0 if not training
                end
            end
            2'b01: begin // State 1
                if (train_valid && train_taken) begin
                    state <= 2'b10; // Increment to state 2
                end else if (train_valid && !train_taken) begin
                    state <= 2'b00; // Decrement to state 0
                end else begin
                    state <= 2'b01; // Stay in state 1 if not training
                end
            end
            2'b10: begin // State 2
                if (train_valid && train_taken) begin
                    state <= 2'b11; // Increment to state 3
                end else if (train_valid && !train_taken) begin
                    state <= 2'b01; // Decrement to state 1
                end else begin
                    state <= 2'b10; // Stay in state 2 if not training
                end
            end
            2'b11: begin // State 3
                if (train_valid && train_taken) begin
                    state <= 2'b11; // Stay in state 3 (saturated)
                end else if (train_valid && !train_taken) begin
                    state <= 2'b10; // Decrement to state 2
                end else begin
                    state <= 2'b11; // Stay in state 3 if not training
                end
            end
            default: begin
                state <= 2'b01; // Default to state 1
            end
        endcase
    end
end

endmodule