module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output reg walk_left,
    output reg walk_right,
    output reg aaah
);

    // Explicit state encoding
    typedef enum {LEFT, RIGHT, FALL} state_t;
    state_t state, next_state;

    // Bump buffer to handle simultaneous bumps
    wire bump_any = bump_left || bump_right;
    wire bump_left_only = bump_left && !bump_right;
    wire bump_right_only = bump_right && !bump_left;

    // State transition logic
    always @(*) begin
        case (state)
            LEFT: begin
                if (!ground) begin
                    next_state = FALL;
                end else if (bump_left_only) begin
                    next_state = RIGHT;
                end else begin
                    next_state = LEFT;
                end
            end
            
            RIGHT: begin
                if (!ground) begin
                    next_state = FALL;
                end else if (bump_right_only) begin
                    next_state = LEFT;
                end else begin
                    next_state = RIGHT;
                end
            end
            
            FALL: begin
                if (ground) begin
                    // Return to previous direction
                    next_state = (state == LEFT) ? LEFT : RIGHT;
                end else begin
                    next_state = FALL;
                end
            end
        endcase
    end

    // State register with async reset
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= LEFT;
        end else begin
            state <= next_state;
        end
    end

    // Registered output logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            walk_left <= 1;
            walk_right <= 0;
            aaah <= 0;
        end else begin
            walk_left <= (next_state == LEFT);
            walk_right <= (next_state == RIGHT);
            aaah <= (next_state == FALL);
        end
    end

endmodule