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
        reg [1:0] next_state;
        
        // Calculate next state based on current state and input conditions
        if (train_valid) begin
            if (train_taken) begin
                next_state = state_reg + 2'b01; // Increment
            end else begin
                next_state = state_reg - 2'b01; // Decrement
            end
        end else begin
            next_state = state_reg; // Maintain current value when not training
        end
        
        // Apply saturation logic
        if (next_state > 2'b11) begin
            state_reg <= 2'b11; // Saturate at maximum value
        end else if (next_state < 2'b00) begin
            state_reg <= 2'b00; // Saturate at minimum value
        end else begin
            state_reg <= next_state; // Update state register with calculated next state
        end
    end
end

endmodule