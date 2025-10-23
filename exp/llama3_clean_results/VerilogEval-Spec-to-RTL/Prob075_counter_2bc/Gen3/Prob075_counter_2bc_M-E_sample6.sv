module TopModule(
    input  clk,
    input  areset,
    input  train_valid,
    input  train_taken,
    output [1:0] state
);

reg [1:0] state_reg;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state_reg <= 2'b01; // Reset to state 1 (weakly not-taken)
    end else if (train_valid) begin
        case (state_reg)
            2'b00: begin // State 0
                if (train_taken) begin
                    state_reg <= 2'b01; // Transition to state 1
                end else begin
                    state_reg <= 2'b00; // Stay at state 0 (saturate)
                end
            end
            2'b01: begin // State 1
                if (train_taken) begin
                    state_reg <= 2'b10; // Transition to state 2
                end else begin
                    state_reg <= 2'b00; // Transition to state 0
                end
            end
            2'b10: begin // State 2
                if (train_taken) begin
                    state_reg <= 2'b11; // Transition to state 3
                end else begin
                    state_reg <= 2'b01; // Transition to state 1
                end
            end
            2'b11: begin // State 3
                if (train_taken) begin
                    state_reg <= 2'b11; // Stay at state 3 (saturate)
                end else begin
                    state_reg <= 2'b10; // Transition to state 2
                end
            end
        endcase
    end else begin
        // When train_valid is low, stay in the current state
        state_reg <= state_reg;
    end
end

assign state = state_reg;

endmodule