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

    // Enumerated states
    typedef enum reg [1:0] {
        WALK_LEFT  = 2'b00,
        WALK_RIGHT = 2'b01,
        FALLING    = 2'b10
    } state_t;

    state_t state, next_state;
    reg direction; // Remember direction during falling: 0=left,1=right

    // Sequential state update with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state     <= WALK_LEFT;
            direction <= 1'b0;
        end else begin
            state <= next_state;
            // Update direction only in walking states, or retain during falling
            if (state != FALLING) begin
                case (next_state)
                    WALK_LEFT:  direction <= 1'b0;
                    WALK_RIGHT: direction <= 1'b1;
                    FALLING:    direction <= direction; // hold direction
                    default:    direction <= direction;
                endcase
            end
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            WALK_LEFT: begin
                if (!ground) begin
                    next_state = FALLING; // start falling, direction stored
                end else if (bump_left && bump_right) begin
                    next_state = WALK_RIGHT; // flip direction
                end else if (bump_left) begin
                    next_state = WALK_RIGHT; // bumped left -> walk right
                end else if (bump_right) begin
                    next_state = WALK_LEFT;  // bumped right -> walk left (no change)
                end else begin
                    next_state = WALK_LEFT;  // no change
                end
            end

            WALK_RIGHT: begin
                if (!ground) begin
                    next_state = FALLING; // start falling
                end else if (bump_left && bump_right) begin
                    next_state = WALK_LEFT; // flip direction
                end else if (bump_left) begin
                    next_state = WALK_RIGHT; // bumped left -> walk right (no change)
                end else if (bump_right) begin
                    next_state = WALK_LEFT;  // bumped right -> walk left
                end else begin
                    next_state = WALK_RIGHT; // no change
                end
            end

            FALLING: begin
                if (ground) begin
                    // Return to walking in stored direction
                    next_state = (direction == 1'b0) ? WALK_LEFT : WALK_RIGHT;
                end else begin
                    next_state = FALLING;
                end
            end

            default: next_state = WALK_LEFT; // safe default
        endcase
    end

    // Output logic (Moore machine)
    assign aaah       = (state == FALLING);
    assign walk_left  = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);

endmodule