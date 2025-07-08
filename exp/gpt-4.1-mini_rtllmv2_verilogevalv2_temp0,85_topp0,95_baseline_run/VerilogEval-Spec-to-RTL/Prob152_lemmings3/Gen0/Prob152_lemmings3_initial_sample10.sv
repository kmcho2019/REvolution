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

// State encoding
typedef enum logic [1:0] {
    WALK_LEFT  = 2'b00,
    WALK_RIGHT = 2'b01,
    FALL       = 2'b10,
    DIG        = 2'b11
} state_t;

state_t state, next_state;

// Keep track of walking direction for restoring after fall or dig
// 0 = left, 1 = right
reg walk_dir, next_walk_dir;

wire bumped = bump_left | bump_right;

// State and walk_dir registers with async posedge reset
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
        walk_dir <= 1'b0; // left
    end else begin
        state <= next_state;
        walk_dir <= next_walk_dir;
    end
end

// Next state logic
always @(*) begin
    next_state = state;
    next_walk_dir = walk_dir;

    case(state)
        WALK_LEFT: begin
            // Priorities: fall > dig > bump
            if (!ground) begin
                next_state = FALL;
                next_walk_dir = 1'b0; // keep current direction left
            end else if (dig) begin
                next_state = DIG;
                next_walk_dir = 1'b0;
            end else if (bumped) begin
                // Switch direction to right
                next_state = WALK_RIGHT;
                next_walk_dir = 1'b1;
            end else begin
                next_state = WALK_LEFT;
                next_walk_dir = 1'b0;
            end
        end

        WALK_RIGHT: begin
            if (!ground) begin
                next_state = FALL;
                next_walk_dir = 1'b1;
            end else if (dig) begin
                next_state = DIG;
                next_walk_dir = 1'b1;
            end else if (bumped) begin
                // Switch direction to left
                next_state = WALK_LEFT;
                next_walk_dir = 1'b0;
            end else begin
                next_state = WALK_RIGHT;
                next_walk_dir = 1'b1;
            end
        end

        FALL: begin
            // If ground is back, return to walking in stored direction
            if (ground) begin
                if (walk_dir == 1'b0) begin
                    next_state = WALK_LEFT;
                end else begin
                    next_state = WALK_RIGHT;
                end
                // walk_dir stays same
            end else begin
                next_state = FALL;
                // walk_dir unchanged
            end
        end

        DIG: begin
            // fall has highest priority even when digging
            if (!ground) begin
                next_state = FALL;
                // walk_dir unchanged
            end else if (!dig) begin
                // dig stopped, return to walking in stored direction
                if (walk_dir == 1'b0) begin
                    next_state = WALK_LEFT;
                end else begin
                    next_state = WALK_RIGHT;
                end
            end else begin
                next_state = DIG;
                // walk_dir unchanged
            end
        end

        default: begin
            // Safety fallback to walk_left
            next_state = WALK_LEFT;
            next_walk_dir = 1'b0;
        end
    endcase
end

// Output logic (Moore outputs)
always @(*) begin
    walk_left = 1'b0;
    walk_right = 1'b0;
    aaah = 1'b0;
    digging = 1'b0;

    case(state)
        WALK_LEFT: walk_left = 1'b1;
        WALK_RIGHT: walk_right = 1'b1;
        FALL: aaah = 1'b1;
        DIG: digging = 1'b1;
    endcase
end

endmodule