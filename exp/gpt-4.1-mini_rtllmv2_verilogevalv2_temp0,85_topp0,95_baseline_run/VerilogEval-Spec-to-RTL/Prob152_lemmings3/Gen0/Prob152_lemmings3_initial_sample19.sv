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
    typedef enum reg [1:0] {
        WALK_LEFT  = 2'b00,
        WALK_RIGHT = 2'b01,
        FALLING    = 2'b10,
        DIGGING    = 2'b11
    } state_t;

    state_t state, next_state;
    // To remember walking direction before falling or digging
    state_t walking_dir;

    // Asynchronous reset + synchronous state update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            walking_dir <= WALK_LEFT;
        end else begin
            state <= next_state;
            // Update walking_dir only when walking states or starting to walk from falling/digging
            // walking_dir tracks direction to return to after falling/digging
            if (next_state == WALK_LEFT || next_state == WALK_RIGHT)
                walking_dir <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        // Default next state is current state
        next_state = state;

        case(state)
            WALK_LEFT, WALK_RIGHT: begin
                // On ground and walking
                if (!ground) begin
                    // Fall has highest priority
                    next_state = FALLING;
                end else if (dig) begin
                    // Dig if dig=1 and on ground and walking
                    next_state = DIGGING;
                end else begin
                    // Check bumps to switch direction
                    // Bump on either side causes direction switch
                    if (bump_left || bump_right) begin
                        if (state == WALK_LEFT)
                            next_state = WALK_RIGHT;
                        else
                            next_state = WALK_LEFT;
                    end
                end
            end

            FALLING: begin
                // If ground reappears, resume walking direction
                if (ground)
                    next_state = walking_dir;
                else
                    next_state = FALLING;
            end

            DIGGING: begin
                // Digging only stops when ground disappears (fall)
                if (!ground)
                    next_state = FALLING;
                else
                    next_state = DIGGING;
            end

            default: next_state = WALK_LEFT; // safety
        endcase
    end

    // Output logic (Moore)
    always @(*) begin
        walk_left = 0;
        walk_right = 0;
        aaah = 0;
        digging = 0;

        case(state)
            WALK_LEFT:  walk_left = 1;
            WALK_RIGHT: walk_right = 1;
            FALLING:    aaah = 1;
            DIGGING:    digging = 1;
        endcase
    end

endmodule