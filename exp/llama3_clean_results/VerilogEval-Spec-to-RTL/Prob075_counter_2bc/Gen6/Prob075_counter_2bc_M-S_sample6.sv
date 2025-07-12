module TopModule(
    input           clk,
    input           areset,
    input           train_valid,
    input           train_taken,
    output reg [1:0] state
);

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01; // Reset to state 1 (weakly not-taken)
    end else begin
        if (train_valid) begin
            if (train_taken) begin
                state <= (state == 2'b11) ? 2'b11 : state + 1; // Increment, saturate at 3
            end else begin
                state <= (state == 2'b00) ? 2'b00 : state - 1; // Decrement, saturate at 0
            end
        end else begin
            state <= state; // Keep state unchanged if not training
        end
    end
end

endmodule