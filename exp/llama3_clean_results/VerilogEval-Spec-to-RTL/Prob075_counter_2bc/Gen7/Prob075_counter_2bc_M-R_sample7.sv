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
                nextState = (state == 2'b11) ? 2'b11 : state + 1'b1; // Increment
            end else begin
                nextState = (state == 2'b00) ? 2'b00 : state - 1'b1; // Decrement
            end
        end else begin
            nextState = state; // Stay unchanged if not training
        end
        state <= nextState;
    end
end

endmodule