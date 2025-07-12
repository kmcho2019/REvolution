module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

    // State encoding
    typedef enum logic [1:0] {WALKING=2'b00, DIGGING=2'b01, FALLING=2'b10} state_t;
    state_t state, next_state;

    reg dir, next_dir;  // 0=left, 1=right
    reg saved_dir, next_saved_dir;

    // Sequential logic with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALKING;
            dir <= 1'b0;       // start walking left
            saved_dir <= 1'b0;
        end else begin
            state <= next_state;
            dir <= next_dir;
            saved_dir <= next_saved_dir;
        end
    end

    // Next state and direction logic
    always @* begin
        // Defaults
        next_state = state;
        next_dir = dir;
        next_saved_dir = saved_dir;

        case (state)
            WALKING: begin
                if (ground == 1'b0) begin
                    // Fall
                    next_state = FALLING;
                    next_saved_dir = dir;
                end else if (dig == 1'b1) begin
                    // Start digging
                    next_state = DIGGING;
                end else if (bump_left | bump_right) begin
                    // Switch direction
                    next_dir = ~dir;
                end
            end
            DIGGING: begin
                if (ground == 1'b0) begin
                    // Ground lost while digging: fall
                    next_state = FALLING;
                    next_saved_dir = dir;
                end
                // else remain digging
            end
            FALLING: begin
                if (ground == 1'b1) begin
                    // Land, resume walking in saved direction
                    next_state = WALKING;
                    next_dir = saved_dir;
                end
                // else remain falling
            end
            default: begin
                next_state = WALKING;
                next_dir = 1'b0;
                next_saved_dir = 1'b0;
            end
        endcase
    end

    // Output logic
    assign walk_left  = (state == WALKING) && (dir == 1'b0);
    assign walk_right = (state == WALKING) && (dir == 1'b1);
    assign digging    = (state == DIGGING);
    assign aaah       = (state == FALLING);

endmodule