module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);

// Using binary encoding for states to reduce area
reg [1:0] state, next_state;
reg walk_direction, next_walk_direction;

// Clear and descriptive variable names for readability
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        // Initialize state to WALKING (2'b00) and walk direction to left (0)
        state <= 2'b00;
        walk_direction <= 0;
    end else begin
        // Update state and walk direction on the positive edge of the clock
        state <= next_state;
        walk_direction <= next_walk_direction;
    end
end

// Simplified state transition logic to reduce critical path delays
always_comb begin
    next_state = state;
    next_walk_direction = walk_direction;

    case (state)
        2'b00: // WALKING
            if (!ground) begin
                next_state = 2'b01; // FALLING
            end else if (dig) begin
                next_state = 2'b10; // DIGGING
            end else if (bump_left || bump_right) begin
                next_walk_direction = ~walk_direction; // Change walk direction
            end
        2'b01: // FALLING
            if (ground) begin
                next_state = 2'b00; // Resume walking
            end
        2'b10: // DIGGING
            if (!ground) begin
                next_state = 2'b01; // FALLING
            end
    endcase
end

// Simplified output logic to reduce area and improve performance
assign walk_left = (state == 2'b00 && ~walk_direction);
assign walk_right = (state == 2'b00 && walk_direction);
assign aaah = (state == 2'b01);
assign digging = (state == 2'b10);

endmodule