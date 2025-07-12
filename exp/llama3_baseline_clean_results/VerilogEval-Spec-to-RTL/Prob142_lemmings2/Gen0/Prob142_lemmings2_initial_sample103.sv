module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah
);

// Define states
enum logic [1:0] {
    WALK_LEFT,
    WALK_RIGHT,
    FALLING
} state, next_state;

// Sequential logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
    end else begin
        state <= next_state;
    end
end

// Combinational logic
always_comb begin
    next_state = state;
    walk_left = 1'b0;
    walk_right = 1'b0;
    aaah = 1'b0;

    case (state)
        WALK_LEFT: begin
            walk_left = 1'b1;
            if (bump_left) begin
                next_state = WALK_RIGHT;
            end else if (~ground) begin
                next_state = FALLING;
            end
        end
        WALK_RIGHT: begin
            walk_right = 1'b1;
            if (bump_right) begin
                next_state = WALK_LEFT;
            end else if (~ground) begin
                next_state = FALLING;
            end
        end
        FALLING: begin
            aaah = 1'b1;
            if (ground) begin
                if (next_state == WALK_LEFT) begin
                    next_state = WALK_LEFT;
                end else if (next_state == WALK_RIGHT) begin
                    next_state = WALK_RIGHT;
                end else begin
                    next_state = WALK_LEFT; // default to WALK_LEFT if not explicitly set
                end
            end
        end
    endcase

    // Handle bumps when falling or transitioning to/from falling
    if (~ground && (bump_left || bump_right)) begin
        // Ignore bumps when falling or transitioning to/from falling
    end else if (state == FALLING && ground) begin
        // Ignore bumps when transitioning from falling to walking
    end else if (~ground && state != FALLING) begin
        // Ignore bumps when transitioning from walking to falling
    end else begin
        if (bump_left && bump_right) begin
            // If both bump_left and bump_right are high, switch direction
            if (state == WALK_LEFT) begin
                next_state = WALK_RIGHT;
            end else if (state == WALK_RIGHT) begin
                next_state = WALK_LEFT;
            end
        end else if (bump_left) begin
            next_state = WALK_RIGHT;
        end else if (bump_right) begin
            next_state = WALK_LEFT;
        end
    end
end

endmodule