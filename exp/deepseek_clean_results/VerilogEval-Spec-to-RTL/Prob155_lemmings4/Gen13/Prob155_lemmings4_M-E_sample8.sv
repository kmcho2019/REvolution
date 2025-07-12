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

    // State encoding
    typedef enum logic [1:0] {
        WALKING,
        FALLING,
        DIGGING,
        SPLATTERED
    } state_t;

    // Direction encoding
    typedef enum logic {
        LEFT,
        RIGHT
    } dir_t;

    state_t current_state, next_state;
    dir_t current_dir, next_dir;
    reg [4:0] fall_timer;

    // State and direction transition
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            current_state <= WALKING;
            current_dir <= LEFT;
            fall_timer <= 0;
        end else begin
            current_state <= next_state;
            current_dir <= next_dir;
            
            // Update fall timer
            if (current_state == FALLING && !ground) begin
                fall_timer <= fall_timer + 1;
            end else begin
                fall_timer <= 0;
            end
        end
    end

    // Next state and direction logic
    always_comb begin
        // Default to current values
        next_state = current_state;
        next_dir = current_dir;

        case (current_state)
            WALKING: begin
                if (!ground) begin
                    next_state = FALLING;
                end else if (dig) begin
                    next_state = DIGGING;
                end else if ((current_dir == LEFT && bump_left) || 
                            (current_dir == RIGHT && bump_right)) begin
                    next_dir = (current_dir == LEFT) ? RIGHT : LEFT;
                end
            end

            DIGGING: begin
                if (!ground) begin
                    next_state = FALLING;
                end
            end

            FALLING: begin
                if (ground) begin
                    if (fall_timer > 20) begin
                        next_state = SPLATTERED;
                    end else begin
                        next_state = WALKING;
                    end
                end
            end

            SPLATTERED: begin
                // Stay splattered forever
                next_state = SPLATTERED;
            end
        endcase
    end

    // Output logic
    assign walk_left = (current_state == WALKING) && (current_dir == LEFT);
    assign walk_right = (current_state == WALKING) && (current_dir == RIGHT);
    assign aaah = (current_state == FALLING);
    assign digging = (current_state == DIGGING);

endmodule