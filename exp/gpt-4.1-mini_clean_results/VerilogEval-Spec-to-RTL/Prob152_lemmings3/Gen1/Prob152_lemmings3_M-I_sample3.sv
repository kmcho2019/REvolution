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

    typedef enum logic [2:0] {
        WALK_LEFT    = 3'd0,
        WALK_RIGHT   = 3'd1,
        FALLING      = 3'd2,
        DIGGING_LEFT  = 3'd3,
        DIGGING_RIGHT = 3'd4
    } state_t;

    state_t state, next_state;

    // direction register: 1 = left, 0 = right
    reg dir_is_left;

    // Next state logic - single unified combinational block
    always @(*) begin
        // Default next_state stays same as current state
        next_state = state;

        case (state)
            // Walking states
            WALK_LEFT: begin
                if (ground == 0) begin
                    // fall has highest priority
                    next_state = FALLING;
                end else if (dig == 1) begin
                    // dig allowed only if walking and ground=1
                    next_state = DIGGING_LEFT;
                end else if (bump_left || bump_right) begin
                    // bump causes direction switch if ground present and walking
                    next_state = WALK_RIGHT;
                end else begin
                    next_state = WALK_LEFT;
                end
            end

            WALK_RIGHT: begin
                if (ground == 0) begin
                    next_state = FALLING;
                end else if (dig == 1) begin
                    next_state = DIGGING_RIGHT;
                end else if (bump_left || bump_right) begin
                    next_state = WALK_LEFT;
                end else begin
                    next_state = WALK_RIGHT;
                end
            end

            // Falling state: ignore bumps and dig.
            FALLING: begin
                if (ground == 1) begin
                    // Resume walking in previous direction after fall ends
                    if (dir_is_left)
                        next_state = WALK_LEFT;
                    else
                        next_state = WALK_RIGHT;
                end else begin
                    next_state = FALLING;
                end
            end

            // Digging states: ignore bumps and dig commands
            DIGGING_LEFT: begin
                if (ground == 0) begin
                    // ground gone -> start falling
                    next_state = FALLING;
                end else begin
                    next_state = DIGGING_LEFT;
                end
            end

            DIGGING_RIGHT: begin
                if (ground == 0) begin
                    next_state = FALLING;
                end else begin
                    next_state = DIGGING_RIGHT;
                end
            end

            default: next_state = WALK_LEFT;
        endcase
    end

    // Sequential logic: state and dir_is_left updates
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            dir_is_left <= 1'b1;
        end else begin
            state <= next_state;

            // Update direction only when next state is walking or digging (means direction known)
            if (next_state == WALK_LEFT || next_state == DIGGING_LEFT) begin
                dir_is_left <= 1'b1;
            end else if (next_state == WALK_RIGHT || next_state == DIGGING_RIGHT) begin
                dir_is_left <= 1'b0;
            end
            // Falling does not change dir_is_left, preserve previous direction
        end
    end

    // Moore output logic based on current state
    always @(*) begin
        walk_left = 1'b0;
        walk_right = 1'b0;
        aaah = 1'b0;
        digging = 1'b0;

        case(state)
            WALK_LEFT: begin
                walk_left = 1'b1;
            end
            WALK_RIGHT: begin
                walk_right = 1'b1;
            end
            FALLING: begin
                aaah = 1'b1;
            end
            DIGGING_LEFT: begin
                digging = 1'b1;
                walk_left = 1'b1;
            end
            DIGGING_RIGHT: begin
                digging = 1'b1;
                walk_right = 1'b1;
            end
            default: begin
                walk_left = 1'b0;
                walk_right = 1'b0;
                aaah = 1'b0;
                digging = 1'b0;
            end
        endcase
    end

endmodule