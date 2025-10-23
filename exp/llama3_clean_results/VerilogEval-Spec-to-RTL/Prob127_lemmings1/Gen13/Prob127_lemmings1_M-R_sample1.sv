module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output logic walk_left,
    output logic walk_right
);

reg state; // Using a 1-bit state variable
reg next_state; // Next state variable

// Combinational logic to update next_state
always @(*) begin
    if (state == 0) begin // Currently in LEFT state
        if (bump_left) begin
            next_state = 1; // Switch to RIGHT state
        end else begin
            next_state = 0; // Stay in LEFT state
        end
    end else begin // Currently in RIGHT state
        if (bump_right) begin
            next_state = 0; // Switch to LEFT state
        end else begin
            next_state = 1; // Stay in RIGHT state
        end
    end
end

// Sequential logic to update state
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0; // Initialize state to LEFT (0)
    end else begin
        state <= next_state; // Update state
    end
end

// Use assign statements for output logic
assign walk_left = ~state;
assign walk_right = state;

endmodule