module TopModule(
    input  clk,
    input  areset,
    input  train_valid,
    input  train_taken,
    output [1:0] state
);

reg [1:0] state_reg; // Internal register to hold the counter value
assign state = state_reg; // Continuous assignment to output the counter value

always @(posedge clk or posedge areset) begin
    if (areset) begin // Asynchronous reset condition
        state_reg <= 2'b01; // Reset counter to weakly not-taken (2'b01)
    end else if (train_valid) begin // If training is valid
        if (train_taken) begin // Increment counter if train_taken is high
            if (state_reg == 2'b11) begin // Check for saturation at maximum value
                state_reg <= 2'b11; // Do not increment beyond 3
            end else begin
                state_reg <= state_reg + 1'b1; // Increment counter
            end
        end else begin // Decrement counter if train_taken is low
            if (state_reg == 2'b00) begin // Check for saturation at minimum value
                state_reg <= 2'b00; // Do not decrement below 0
            end else begin
                state_reg <= state_reg - 1'b1; // Decrement counter
            end
        end
    end else begin // If not training, keep the counter value unchanged
        state_reg <= state_reg;
    end
end

endmodule