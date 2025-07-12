module TopModule(
    input  clk,
    input  areset,
    input  train_valid,
    input  train_taken,
    output [1:0] state
);

reg [1:0] state_reg; // Internal register to hold the counter value
assign state = state_reg; // Continuous assignment to output the counter value

// Combinational logic to determine the next state
reg [1:0] next_state;
always @(*) begin
    if (train_valid) begin
        if (train_taken) begin
            // Increment counter
            if (state_reg == 2'b11) begin
                next_state = 2'b11; // Saturation at maximum value
            end else begin
                next_state = state_reg + 1'b1;
            end
        end else begin
            // Decrement counter
            if (state_reg == 2'b00) begin
                next_state = 2'b00; // Saturation at minimum value
            end else begin
                next_state = state_reg - 1'b1;
            end
        end
    end else begin
        // If not training, keep the counter value unchanged
        next_state = state_reg;
    end
end

// Sequential logic to update the state register
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state_reg <= 2'b01; // Asynchronous reset
    end else begin
        state_reg <= next_state; // Update state register on rising edge of clock
    end
end

endmodule