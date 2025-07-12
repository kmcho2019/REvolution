module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output reg walk_left,
    output reg walk_right,
    output reg aaah
);

// Define the states
parameter WALK_LEFT = 2'b00;
parameter WALK_RIGHT = 2'b01;
parameter FALLING = 2'b10;

// Internal registers to store the current state and previous direction
reg [1:0] state;
reg [1:0] prev_direction;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        // Asynchronous reset: reset the state to walk left
        state <= WALK_LEFT;
        prev_direction <= WALK_LEFT;
        walk_left <= 1'b1;
        walk_right <= 1'b0;
        aaah <= 1'b0;
    end else begin
        case (state)
            WALK_LEFT: begin
                if (bump_left) begin
                    // Bumped on the left, switch to walking right
                    state <= WALK_RIGHT;
                    walk_left <= 1'b0;
                    walk_right <= 1'b1;
                end else if (bump_right) begin
                    // Bumped on the right, switch to walking left
                    state <= WALK_LEFT;
                    walk_left <= 1'b1;
                    walk_right <= 1'b0;
                end else if (!ground) begin
                    // Ground disappeared, start falling
                    state <= FALLING;
                    prev_direction <= WALK_LEFT;
                    walk_left <= 1'b0;
                    walk_right <= 1'b0;
                    aaah <= 1'b1;
                end else begin
                    // No bumps, keep walking left
                    walk_left <= 1'b1;
                    walk_right <= 1'b0;
                end
            end
            WALK_RIGHT: begin
                if (bump_left) begin
                    // Bumped on the left, switch to walking right
                    state <= WALK_RIGHT;
                    walk_left <= 1'b0;
                    walk_right <= 1'b1;
                end else if (bump_right) begin
                    // Bumped on the right, switch to walking left
                    state <= WALK_LEFT;
                    walk_left <= 1'b1;
                    walk_right <= 1'b0;
                end else if (!ground) begin
                    // Ground disappeared, start falling
                    state <= FALLING;
                    prev_direction <= WALK_RIGHT;
                    walk_left <= 1'b0;
                    walk_right <= 1'b0;
                    aaah <= 1'b1;
                end else begin
                    // No bumps, keep walking right
                    walk_left <= 1'b0;
                    walk_right <= 1'b1;
                end
            end
            FALLING: begin
                if (ground) begin
                    // Ground reappeared, resume walking
                    state <= prev_direction;
                    if (prev_direction == WALK_LEFT) begin
                        walk_left <= 1'b1;
                        walk_right <= 1'b0;
                    end else begin
                        walk_left <= 1'b0;
                        walk_right <= 1'b1;
                    end
                    aaah <= 1'b0;
                end else begin
                    // Keep falling
                    walk_left <= 1'b0;
                    walk_right <= 1'b0;
                    aaah <= 1'b1;
                end
            end
        endcase
    end
end

endmodule