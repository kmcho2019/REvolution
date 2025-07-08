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

    // State encoding
    typedef enum logic [1:0] {
        WALK_LEFT  = 2'b00,
        WALK_RIGHT = 2'b01,
        FALLING    = 2'b10
    } state_t;

    state_t state, next_state;

    // Remember direction before falling
    state_t last_walk_state;

    // Asynchronous reset and state register
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            last_walk_state <= WALK_LEFT;
        end else begin
            state <= next_state;
            if (state != FALLING && ground)
                last_walk_state <= state; // Update last_walk_state only when walking
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case (state)
            WALK_LEFT: begin
                if (!ground) begin
                    next_state = FALLING;
                end else if (bump_left || bump_right) begin
                    // bump on either side causes switch direction
                    next_state = WALK_RIGHT;
                end else begin
                    next_state = WALK_LEFT;
                end
            end
            WALK_RIGHT: begin
                if (!ground) begin
                    next_state = FALLING;
                end else if (bump_left || bump_right) begin
                    next_state = WALK_LEFT;
                end else begin
                    next_state = WALK_RIGHT;
                end
            end
            FALLING: begin
                if (ground) begin
                    next_state = last_walk_state;
                end else begin
                    next_state = FALLING;
                end
            end
            default: next_state = WALK_LEFT;
        endcase
    end

    // Output logic: Moore outputs depend only on state
    always @(*) begin
        walk_left  = 1'b0;
        walk_right = 1'b0;
        aaah       = 1'b0;
        case (state)
            WALK_LEFT:  walk_left = 1'b1;
            WALK_RIGHT: walk_right = 1'b1;
            FALLING:    aaah = 1'b1;
        endcase
    end

endmodule