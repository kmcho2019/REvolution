module TopModule(
    input  wire clk,
    input  wire areset,
    input  wire bump_left,
    input  wire bump_right,
    input  wire ground,
    output wire walk_left,
    output wire walk_right,
    output wire aaah
);
    typedef enum logic [1:0] {
        WALK_LEFT  = 2'b00,
        WALK_RIGHT = 2'b01,
        FALLING    = 2'b10
    } state_t;

    state_t state, next_state;
    state_t saved_walk_state; // remembers walking direction before falling

    wire bump = bump_left | bump_right;
    wire both_bump = bump_left & bump_right;

    // Next state logic
    always @(*) begin
        next_state = state;
        case(state)
            WALK_LEFT: begin
                if (!ground)
                    next_state = FALLING;
                else if (bump) begin
                    if (both_bump || bump_right)
                        next_state = WALK_RIGHT;
                    else
                        next_state = WALK_LEFT;
                end
            end
            WALK_RIGHT: begin
                if (!ground)
                    next_state = FALLING;
                else if (bump) begin
                    if (both_bump || bump_left)
                        next_state = WALK_LEFT;
                    else
                        next_state = WALK_RIGHT;
                end
            end
            FALLING: begin
                if (ground)
                    next_state = saved_walk_state;
                else
                    next_state = FALLING;
            end
        endcase
    end

    // State and saved_walk_state update
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            saved_walk_state <= WALK_LEFT;
        end else begin
            if (state != FALLING && !ground)
                saved_walk_state <= state; // remember direction before falling
            state <= next_state;
        end
    end

    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah       = (state == FALLING);

endmodule