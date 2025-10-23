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

    // State definitions
    typedef enum logic [1:0] {
        WALK,
        FALL,
        DIG,
        SPLATTER
    } state_t;

    // Direction definitions
    typedef enum logic {
        LEFT,
        RIGHT
    } dir_t;

    state_t current_state, next_state;
    dir_t current_dir, next_dir;
    reg [4:0] fall_counter;

    // State and direction registers
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            current_state <= WALK;
            current_dir <= LEFT;
            fall_counter <= 0;
        end else begin
            current_state <= next_state;
            current_dir <= next_dir;
            
            // Update fall counter
            if (current_state == FALL) begin
                fall_counter <= ground ? 0 : fall_counter + 1;
            end else begin
                fall_counter <= 0;
            end
        end
    end

    // Next state and direction logic
    always_comb begin
        // Default values
        next_state = current_state;
        next_dir = current_dir;

        case (current_state)
            WALK: begin
                if (!ground) begin
                    next_state = FALL;
                end else if (dig) begin
                    next_state = DIG;
                end else if ((current_dir == LEFT && bump_left) || 
                           (current_dir == RIGHT && bump_right)) begin
                    next_dir = ~current_dir;  // Toggle direction
                end
            end

            DIG: begin
                if (!ground) begin
                    next_state = FALL;
                end
            end

            FALL: begin
                if (ground) begin
                    if (fall_counter > 20) begin
                        next_state = SPLATTER;
                    end else begin
                        next_state = WALK;
                    end
                end
            end

            SPLATTER: begin
                // Stay in splattered state forever
                next_state = SPLATTER;
            end
        endcase
    end

    // Output logic
    assign walk_left = (current_state == WALK) && (current_dir == LEFT);
    assign walk_right = (current_state == WALK) && (current_dir == RIGHT);
    assign aaah = (current_state == FALL);
    assign digging = (current_state == DIG);

endmodule