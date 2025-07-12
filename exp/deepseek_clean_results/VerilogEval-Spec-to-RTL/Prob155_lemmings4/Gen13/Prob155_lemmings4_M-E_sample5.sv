module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

    // Main states
    typedef enum {WALKING, FALLING, DIGGING, SPLATTER} state_t;
    state_t current_state, next_state;

    // Direction sub-states
    reg direction; // 0=left, 1=right
    reg next_direction;

    // Fall timer
    reg [4:0] fall_timer;
    reg [4:0] next_fall_timer;

    // State transition logic
    always @(*) begin
        // Default assignments
        next_state = current_state;
        next_direction = direction;
        next_fall_timer = fall_timer;

        case (current_state)
            WALKING: begin
                if (!ground) begin
                    next_state = FALLING;
                    next_fall_timer = 0;
                end else if (dig) begin
                    next_state = DIGGING;
                end else begin
                    // Handle direction changes only when walking on ground
                    if (bump_left && !bump_right) begin
                        next_direction = 1; // turn right
                    end else if (bump_right && !bump_left) begin
                        next_direction = 0; // turn left
                    end else if (bump_left && bump_right) begin
                        next_direction = ~direction; // toggle direction
                    end
                end
            end

            FALLING: begin
                if (ground) begin
                    if (fall_timer > 20) begin
                        next_state = SPLATTER;
                    end else begin
                        next_state = WALKING;
                    end
                end else begin
                    next_fall_timer = fall_timer + 1;
                end
            end

            DIGGING: begin
                if (!ground) begin
                    next_state = FALLING;
                    next_fall_timer = 0;
                end
            end

            SPLATTER: begin
                // Stay in splatter state forever
                next_state = SPLATTER;
            end
        endcase
    end

    // State register update
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            current_state <= WALKING;
            direction <= 0; // start walking left
            fall_timer <= 0;
        end else begin
            current_state <= next_state;
            direction <= next_direction;
            fall_timer <= next_fall_timer;
        end
    end

    // Output logic
    assign walk_left = (current_state == WALKING) && !direction && (current_state != SPLATTER);
    assign walk_right = (current_state == WALKING) && direction && (current_state != SPLATTER);
    assign aaah = (current_state == FALLING) && (current_state != SPLATTER);
    assign digging = (current_state == DIGGING) && (current_state != SPLATTER);

endmodule