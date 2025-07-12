module TopModule(
    input           clk,
    input           areset,
    input           train_valid,
    input           train_taken,
    output reg [1:0] state
);

always @(posedge clk) begin
    if (areset) begin
        state <= 2'b01; // Reset to state 1 (weakly not-taken)
    end else begin
        case (state)
            2'b00: begin // State 0
                if (train_valid && train_taken) begin
                    state <= state + 1'b1; // Increment to state 1
                end
            end
            2'b01: begin // State 1
                if (train_valid && train_taken) begin
                    state <= state + 1'b1; // Increment to state 2
                end else if (train_valid &&!train_taken) begin
                    state <= state - 1'b1; // Decrement to state 0
                end
            end
            2'b10: begin // State 2
                if (train_valid && train_taken) begin
                    state <= state + 1'b1; // Increment to state 3
                end else if (train_valid &&!train_taken) begin
                    state <= state - 1'b1; // Decrement to state 1
                end
            end
            2'b11: begin // State 3
                if (train_valid &&!train_taken) begin
                    state <= state - 1'b1; // Decrement to state 2
                end
            end
            default: begin
                state <= 2'b01; // Default to state 1
            end
        endcase
    end
end

endmodule