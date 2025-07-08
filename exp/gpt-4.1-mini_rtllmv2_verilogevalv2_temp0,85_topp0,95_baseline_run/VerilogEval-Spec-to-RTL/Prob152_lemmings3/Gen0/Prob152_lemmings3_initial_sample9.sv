module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);

// Define states
typedef enum logic [1:0] {
    WALK_LEFT      = 2'd0,
    WALK_RIGHT     = 2'd1,
    DIGGING_LEFT   = 2'd2,
    DIGGING_RIGHT  = 2'd3
} state_t;

state_t state, next_state;

// On async reset or clock, update state
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
    end else begin
        state <= next_state;
    end
end

// Next state logic
always_comb begin
    next_state = state; // default hold

    // If ground=0, Lemming is falling -> no state change here,
    // but outputs aaah=1 and no walking/digging outputs.
    // The FSM stays in the same state, representing prior walking/digging.

    // When ground=1 (on ground), normal state transitions occur.

    if (!ground) begin
        // Falling: no state change regardless of bumps or dig.
        // The state stays the same to remember direction and digging,
        // but outputs reflect falling.
        next_state = state;
    end else begin
        // On ground
        case (state)
            WALK_LEFT: begin
                if (dig) begin
                    // start digging left
                    next_state = DIGGING_LEFT;
                end else if (bump_left || bump_right) begin
                    // switch direction on bump
                    // bumped left or right or both means switch direction
                    next_state = WALK_RIGHT;
                end else begin
                    next_state = WALK_LEFT;
                end
            end

            WALK_RIGHT: begin
                if (dig) begin
                    // start digging right
                    next_state = DIGGING_RIGHT;
                end else if (bump_left || bump_right) begin
                    // switch direction on bump
                    next_state = WALK_LEFT;
                end else begin
                    next_state = WALK_RIGHT;
                end
            end

            DIGGING_LEFT: begin
                // Continue digging unless ground disappears
                if (!ground) begin
                    // ground lost during digging -> start falling (state unchanged)
                    next_state = state;
                end else begin
                    // continue digging
                    next_state = DIGGING_LEFT;
                end
            end

            DIGGING_RIGHT: begin
                if (!ground) begin
                    // start falling
                    next_state = state;
                end else begin
                    next_state = DIGGING_RIGHT;
                end
            end

            default: next_state = WALK_LEFT;
        endcase
    end
end

// Output logic (Moore): based on state and ground
always_comb begin
    // Default all outputs to 0
    walk_left = 1'b0;
    walk_right = 1'b0;
    digging = 1'b0;
    aaah = 1'b0;

    if (!ground) begin
        // falling
        aaah = 1'b1;
        // no walking or digging output while falling
    end else begin
        // ground present
        case (state)
            WALK_LEFT: begin
                walk_left = 1'b1;
            end
            WALK_RIGHT: begin
                walk_right = 1'b1;
            end
            DIGGING_LEFT: begin
                digging = 1'b1;
                walk_left = 1'b1; // Lemming continues moving left while digging
            end
            DIGGING_RIGHT: begin
                digging = 1'b1;
                walk_right = 1'b1; // Lemming continues moving right while digging
            end
        endcase
    end
end

endmodule