module TopModule(
    input  clk,
    input  areset,
    input  train_valid,
    input  train_taken,
    output [1:0] state
);

reg [1:0] state_reg; // Internal register to hold the counter value
assign state = state_reg; // Continuous assignment to output the counter value

// Sequential logic to update the state register
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state_reg <= 2'b01; // Asynchronous reset
    end else begin
        if (train_valid) begin
            if (train_taken) begin
                // Increment, but ensure it does not exceed 3
                state_reg <= (state_reg == 2'b11) ? 2'b11 : state_reg + 1'b1;
            end else begin
                // Decrement, but ensure it does not go below 0
                state_reg <= (state_reg == 2'b00) ? 2'b00 : state_reg - 1'b1;
            end
        end else begin
            // If not training, maintain the current value
            state_reg <= state_reg;
        end
    end
end

endmodule