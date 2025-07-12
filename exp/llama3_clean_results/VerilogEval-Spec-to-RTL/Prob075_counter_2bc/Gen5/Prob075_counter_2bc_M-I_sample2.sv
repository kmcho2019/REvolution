module TopModule(
    input           clk,
    input           areset,
    input           train_valid,
    input           train_taken,
    output reg [1:0] state
);

reg [1:0] nextState;

always @(posedge clk) begin
    if (areset) begin
        state <= 2'b01; // Reset to state 1 (weakly not-taken)
    end else begin
        if (train_valid) begin
            if (train_taken) begin
                nextState = state + 1;
            end else begin
                nextState = state - 1;
            end
        end else begin
            nextState = state;
        end

        // Saturating logic
        if (nextState > 3) begin
            state <= 3;
        end else if (nextState < 0) begin
            state <= 0;
        end else begin
            state <= nextState;
        end
    end
end

endmodule