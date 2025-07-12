module TopModule(
    input clk,
    input areset,
    input train_valid,
    input train_taken,
    output reg [1:0] state
);

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01; // Reset to weakly not-taken
    end else begin
        if (train_valid) begin
            if (train_taken) begin
                // Increment, saturating at 3 (2'b11)
                state <= (state == 2'b11)? 2'b11 : state + 1;
            end else begin
                // Decrement, saturating at 0 (2'b00)
                state <= (state == 2'b00)? 2'b00 : state - 1;
            end
        end else begin
            // Hold the current value when not training
            state <= state;
        end
    end
end

endmodule