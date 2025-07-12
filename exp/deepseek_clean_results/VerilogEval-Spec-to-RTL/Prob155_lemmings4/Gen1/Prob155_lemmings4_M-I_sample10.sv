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

    // Parameters
    parameter FALL_THRESHOLD = 5'd20;  // Max fall cycles before splatter
    
    // State encoding (one-hot for better timing)
    typedef enum logic [4:0] {
        WALK_L  = 5'b00001,
        WALK_R  = 5'b00010,
        FALLING = 5'b00100,
        DIGGING = 5'b01000,
        SPLAT   = 5'b10000
    } state_t;

    state_t state, next_state;
    reg [4:0] fall_counter;  // 5-bit counter (0-31)

    // State transition logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK_L;
            fall_counter <= 0;
        end else begin
            state <= next_state;
            
            // Update fall counter
            if (state == FALLING && !ground) begin
                fall_counter <= fall_counter + 1;
            end else begin
                fall_counter <= 0;
            end
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            WALK_L: begin
                if (!ground) begin
                    next_state = FALLING;
                end else if (dig) begin
                    next_state = DIGGING;
                end else if (bump_left) begin
                    next_state = WALK_R;
                end else begin
                    next_state = WALK_L;
                end
            end
            
            WALK_R: begin
                if (!ground) begin
                    next_state = FALLING;
                end else if (dig) begin
                    next_state = DIGGING;
                end else if (bump_right) begin
                    next_state = WALK_L;
                end else begin
                    next_state = WALK_R;
                end
            end
            
            FALLING: begin
                if (ground) begin
                    if (fall_counter > FALL_THRESHOLD) begin
                        next_state = SPLAT;
                    end else begin
                        // Return to previous direction
                        next_state = (state == WALK_L) ? WALK_L : WALK_R;
                    end
                end else begin
                    next_state = FALLING;
                end
            end
            
            DIGGING: begin
                if (!ground) begin
                    next_state = FALLING;
                end else begin
                    next_state = DIGGING;
                end
            end
            
            SPLAT: begin
                next_state = SPLAT;  // Terminal state
            end
            
            default: begin
                next_state = WALK_L;  // Default to walk left
            end
        endcase
    end

    // Output logic (Moore style)
    assign walk_left = (state == WALK_L) && (state != SPLAT);
    assign walk_right = (state == WALK_R) && (state != SPLAT);
    assign aaah = (state == FALLING);
    assign digging = (state == DIGGING);

endmodule