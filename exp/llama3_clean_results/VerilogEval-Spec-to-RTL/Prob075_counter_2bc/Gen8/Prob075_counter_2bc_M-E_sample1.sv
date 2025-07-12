module TopModule(
    input           clk,
    input           areset,
    input           train_valid,
    input           train_taken,
    output reg [1:0] state
);

reg [1:0] next_state;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01; // Reset to state 1 (weakly not-taken)
    end else begin
        if (train_valid) begin
            if (train_taken) begin
                // Increment counter
                if (state == 2'b11) begin
                    // Saturation condition: stay at maximum value
                    next_state = 2'b11;
                end else begin
                    next_state = state + 1;
                end
            end else begin
                // Decrement counter
                if (state == 2'b00) begin
                    // Saturation condition: stay at minimum value
                    next_state = 2'b00;
                end else begin
                    next_state = state - 1;
                end
            end
        end else begin
            // Not training: keep current state
            next_state = state;
        end
        state <= next_state;
    end
end

endmodule