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
    typedef enum reg [1:0] {
        WALK_LEFT  = 2'b00,
        WALK_RIGHT = 2'b01,
        FALLING    = 2'b10
    } state_t;

    state_t state, next_state;
    state_t saved_dir;  // stores walking direction before falling

    // Asynchronous reset and state register
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            saved_dir <= WALK_LEFT;
        end else begin
            state <= next_state;
            // Update saved_dir only when transitioning into walking states
            if (ground && (next_state == WALK_LEFT || next_state == WALK_RIGHT)) begin
                saved_dir <= next_state;
            end
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;

        case(state)
            WALK_LEFT: begin
                if (!ground) begin
                    // Start falling, save direction done in sequential block
                    next_state = FALLING;
                end else if (bump_left || bump_right) begin
                    // Change direction when bumped on either or both sides
                    next_state = WALK_RIGHT;
                end
            end
            WALK_RIGHT: begin
                if (!ground) begin
                    next_state = FALLING;
                end else if (bump_left || bump_right) begin
                    next_state = WALK_LEFT;
                end
            end
            FALLING: begin
                if (ground) begin
                    // Resume saved walking direction after falling
                    next_state = saved_dir;
                end
                // bumps ignored while falling
            end
        endcase
    end

    // Output logic (Moore outputs depend only on current state)
    always @(*) begin
        walk_left  = 1'b0;
        walk_right = 1'b0;
        aaah       = 1'b0;

        case(state)
            WALK_LEFT:  walk_left  = 1'b1;
            WALK_RIGHT: walk_right = 1'b1;
            FALLING:    aaah       = 1'b1;
        endcase
    end

endmodule