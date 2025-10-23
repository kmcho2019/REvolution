module TopModule(
    input  clk,
    input  areset,
    input  train_valid,
    input  train_taken,
    output [1:0] state
);

reg [1:0] state_reg; // Internal register to hold the counter value
assign state = state_reg; // Continuous assignment to output the counter value

// Combinational logic to determine next state
wire [1:0] next_state;
reg clk_enable; // Clock enable for clock gating

// Determine clock enable condition
always @(*) begin
    clk_enable = train_valid; // Clock enable only when training is valid
end

// Simplified next_state logic
always @(*) begin
    if (train_taken) begin
        if (state_reg == 2'b11) begin
            next_state = 2'b11; // Saturate at maximum
        end else begin
            next_state = state_reg + 1'b1;
        end
    end else if (train_valid) begin // train_taken is 0
        if (state_reg == 2'b00) begin
            next_state = 2'b00; // Saturate at minimum
        end else begin
            next_state = state_reg - 1'b1;
        end
    end else begin
        next_state = state_reg; // No change when not training
    end
end

// Sequential logic with clock gating
always @(posedge clk or posedge areset) begin
    if (areset) begin // Asynchronous reset condition
        state_reg <= 2'b01; // Reset counter to weakly not-taken (2'b01)
    end else if (clk_enable) begin // Update only when clock is enabled
        state_reg <= next_state; // Update state register based on next_state
    end
end

endmodule