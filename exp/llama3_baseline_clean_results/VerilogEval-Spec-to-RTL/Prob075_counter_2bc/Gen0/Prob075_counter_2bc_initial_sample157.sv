module TopModule (
    input         clk,
    input         areset,
    input         train_valid,
    input         train_taken,
    output  [1:0] state
);

reg [1:0] state;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01; // Reset to weakly not-taken state
    end else begin
        if (train_valid) begin
            if (train_taken) begin
                state <= (state == 2'b11) ? 2'b11 : state + 1; // Increment, but don't exceed 3
            end else begin
                state <= (state == 2'b00) ? 2'b00 : state - 1; // Decrement, but don't go below 0
            end
        end
    end
end

endmodule