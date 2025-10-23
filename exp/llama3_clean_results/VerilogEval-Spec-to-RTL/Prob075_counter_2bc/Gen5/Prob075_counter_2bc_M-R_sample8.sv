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
        if (train_valid) begin
            if (train_taken) begin
                if (state == 2'b11) begin
                    state <= 2'b11; // Saturated at maximum value
                end else begin
                    state <= state + 1'b1; // Increment state
                end
            end else begin
                if (state == 2'b00) begin
                    state <= 2'b00; // Saturated at minimum value
                end else begin
                    state <= state - 1'b1; // Decrement state
                end
            end
        end else begin
            state <= state; // Keep state unchanged if not training
        end
    end
end

endmodule