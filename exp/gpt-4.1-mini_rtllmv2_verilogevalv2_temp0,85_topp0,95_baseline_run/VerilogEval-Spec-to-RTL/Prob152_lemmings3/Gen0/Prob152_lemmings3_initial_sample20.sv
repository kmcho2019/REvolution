module TopModule (
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

// State encoding:
// 0: WALK_LEFT
// 1: WALK_RIGHT
// 2: FALLING_LEFT
// 3: FALLING_RIGHT
// 4: DIGGING_LEFT
// 5: DIGGING_RIGHT

typedef enum reg [2:0] {
    WALK_LEFT = 3'd0,
    WALK_RIGHT = 3'd1,
    FALLING_LEFT = 3'd2,
    FALLING_RIGHT = 3'd3,
    DIGGING_LEFT = 3'd4,
    DIGGING_RIGHT = 3'd5
} state_t;

state_t state, next_state;

wire bumped = bump_left | bump_right;
wire bump_both = bump_left & bump_right;
wire bump_left_only = bump_left & ~bump_right;
wire bump_right_only = bump_right & ~bump_left;

always @(*) begin
    // Default next state is current state
    next_state = state;

    case(state)
        // Walking states
        WALK_LEFT: begin
            if (!ground) begin
                // fall left if no ground
                next_state = FALLING_LEFT;
            end else if (dig) begin
                // start digging left if dig asserted and on ground
                next_state = DIGGING_LEFT;
            end else if (bumped) begin
                // bump changes direction to right
                next_state = WALK_RIGHT;
            end
            // else remain walking left
        end
        WALK_RIGHT: begin
            if (!ground) begin
                next_state = FALLING_RIGHT;
            end else if (dig) begin
                next_state = DIGGING_RIGHT;
            end else if (bumped) begin
                next_state = WALK_LEFT;
            end
        end

        // Falling states
        FALLING_LEFT: begin
            if (ground) begin
                // land and resume walking left
                next_state = WALK_LEFT;
            end
            // else keep falling
        end
        FALLING_RIGHT: begin
            if (ground) begin
                next_state = WALK_RIGHT;
            end
        end

        // Digging states
        DIGGING_LEFT: begin
            if (!ground) begin
                // no ground => fall left
                next_state = FALLING_LEFT;
            end
            // else remain digging left
        end
        DIGGING_RIGHT: begin
            if (!ground) begin
                next_state = FALLING_RIGHT;
            end
        end

        default: next_state = WALK_LEFT; // default reset state
    endcase
end

// Sequential logic with asynchronous positive edge reset
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
    end else begin
        state <= next_state;
    end
end

// Output logic (Moore machine)
always @(*) begin
    // Default outputs
    walk_left = 0;
    walk_right = 0;
    aaah = 0;
    digging = 0;

    case(state)
        WALK_LEFT: begin
            walk_left = 1;
        end
        WALK_RIGHT: begin
            walk_right = 1;
        end
        FALLING_LEFT, FALLING_RIGHT: begin
            aaah = 1;
        end
        DIGGING_LEFT: begin
            digging = 1;
            walk_left = 1;
        end
        DIGGING_RIGHT: begin
            digging = 1;
            walk_right = 1;
        end
    endcase
end

endmodule