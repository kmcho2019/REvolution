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
    state_t prev_walk_state; // to remember walking direction before falling

    // Asynchronous reset and state register
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            prev_walk_state <= WALK_LEFT;
        end else begin
            state <= next_state;
            // Update prev_walk_state only on walking states
            if (state == WALK_LEFT || state == WALK_RIGHT) begin
                prev_walk_state <= state;
            end
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
                    // return to previous walking direction
                    next_state = prev_walk_state;
                end
            end
        endcase
    end

    // Output logic (Moore)
    always @(*) begin
        walk_left = 0;
        walk_right = 0;
        aaah = 0;

        case (state)
            WALK_LEFT: begin
                walk_left = 1;
            end
            WALK_RIGHT: begin
                walk_right = 1;
            end
            FALLING: begin
                aaah = 1;
            end
        endcase
    end
endmodule