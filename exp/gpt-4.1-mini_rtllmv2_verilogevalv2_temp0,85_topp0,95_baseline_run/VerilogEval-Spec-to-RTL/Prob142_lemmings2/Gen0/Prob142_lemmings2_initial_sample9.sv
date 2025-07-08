module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire bump_left,
    input  wire bump_right,
    input  wire ground,
    output reg  walk_left,
    output reg  walk_right,
    output reg  aaah
);

    typedef enum logic [1:0] {
        WALK_LEFT  = 2'b00,
        WALK_RIGHT = 2'b01,
        FALLING    = 2'b10
    } state_t;

    state_t state, next_state;
    state_t prev_walk_state; // stores WALK_LEFT or WALK_RIGHT before falling

    // State register with asynchronous posedge reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            prev_walk_state <= WALK_LEFT;
        end else begin
            state <= next_state;
            // Update prev_walk_state only when entering FALLING state
            if (next_state == FALLING && state != FALLING) begin
                prev_walk_state <= state; // store current walking direction before falling
            end
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            WALK_LEFT: begin
                if (!ground)
                    next_state = FALLING;
                else if (bump_left || bump_right)
                    next_state = WALK_RIGHT;
                else
                    next_state = WALK_LEFT;
            end

            WALK_RIGHT: begin
                if (!ground)
                    next_state = FALLING;
                else if (bump_left || bump_right)
                    next_state = WALK_LEFT;
                else
                    next_state = WALK_RIGHT;
            end

            FALLING: begin
                if (ground)
                    next_state = prev_walk_state; // resume previous walking direction
                else
                    next_state = FALLING;
            end

            default: next_state = WALK_LEFT;
        endcase
    end

    // Output logic - Moore machine outputs based on state
    always @(*) begin
        case (state)
            WALK_LEFT: begin
                walk_left  = 1'b1;
                walk_right = 1'b0;
                aaah       = 1'b0;
            end
            WALK_RIGHT: begin
                walk_left  = 1'b0;
                walk_right = 1'b1;
                aaah       = 1'b0;
            end
            FALLING: begin
                walk_left  = 1'b0;
                walk_right = 1'b0;
                aaah       = 1'b1;
            end
            default: begin
                walk_left  = 1'b1;
                walk_right = 1'b0;
                aaah       = 1'b0;
            end
        endcase
    end

endmodule