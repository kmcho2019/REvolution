module TopModule(
    input  clk,
    input  areset,
    input  train_valid,
    input  train_taken,
    output reg [1:0] state
);

reg [1:0] next_state;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01; // Reset to state 1 (weakly not-taken)
    end else if (train_valid) begin
        if (train_taken) begin
            next_state = state + 1;
            // Saturate the counter at 3
            if (next_state > 3) begin
                next_state = 3;
            end
        end else begin
            next_state = state - 1;
            // Saturate the counter at 0
            if (next_state < 0) begin
                next_state = 0;
            end
        end
        state <= next_state;
    end else begin
        // When train_valid is low, stay in the current state
        state <= state;
    end
end

endmodule