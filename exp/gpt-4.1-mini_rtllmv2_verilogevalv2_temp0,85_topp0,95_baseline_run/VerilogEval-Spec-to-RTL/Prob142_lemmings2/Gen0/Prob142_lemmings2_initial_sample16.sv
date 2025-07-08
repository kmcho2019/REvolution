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

    typedef enum reg [1:0] {
        WALK_LEFT = 2'b00,
        WALK_RIGHT = 2'b01,
        FALLING = 2'b10
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
            // Update prev_walk_state only when walking (not falling)
            if (state != FALLING)
                prev_walk_state <= state;
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case(state)
            WALK_LEFT: begin
                if (ground == 1) begin
                    if (bump_left || bump_right) 
                        next_state = WALK_RIGHT;
                end else begin
                    next_state = FALLING;
                end
            end

            WALK_RIGHT: begin
                if (ground == 1) begin
                    if (bump_left || bump_right) 
                        next_state = WALK_LEFT;
                end else begin
                    next_state = FALLING;
                end
            end

            FALLING: begin
                // Ignore bumps while falling
                if (ground == 1) begin
                    next_state = prev_walk_state;
                end
            end

            default: next_state = WALK_LEFT;
        endcase
    end

    // Output logic (Moore outputs)
    always @(*) begin
        walk_left = 0;
        walk_right = 0;
        aaah = 0;
        case(state)
            WALK_LEFT: walk_left = 1;
            WALK_RIGHT: walk_right = 1;
            FALLING: aaah = 1;
        endcase
    end

endmodule