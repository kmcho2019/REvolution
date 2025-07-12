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

    // One-hot state encoding
    localparam 
        WALK_LEFT  = 4'b0001,
        WALK_RIGHT = 4'b0010,
        FALL_LEFT  = 4'b0100,
        FALL_RIGHT = 4'b1000,
        DIG_LEFT   = 4'b0001,  // Shares with WALK_LEFT
        DIG_RIGHT  = 4'b0010,  // Shares with WALK_RIGHT
        SPLAT      = 4'b0000;
    
    reg [3:0] state, next_state;
    reg [4:0] fall_timer;
    wire is_walking_left  = state[0];
    wire is_walking_right = state[1];
    wire is_falling_left  = state[2];
    wire is_falling_right = state[3];
    wire is_digging_left  = (state == DIG_LEFT);
    wire is_digging_right = (state == DIG_RIGHT);
    wire is_splat         = (state == SPLAT);

    // State register
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
        end else begin
            state <= next_state;
        end
    end

    // Fall timer logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            fall_timer <= 0;
        end else if (is_falling_left || is_falling_right) begin
            fall_timer <= ground ? 0 : fall_timer + 1;
        end else begin
            fall_timer <= 0;
        end
    end

    // Next state logic - combinational
    always @(*) begin
        case (1'b1)
            is_walking_left: begin
                if (~ground)          next_state = FALL_LEFT;
                else if (dig)          next_state = DIG_LEFT;
                else if (bump_left)    next_state = WALK_RIGHT;
                else                   next_state = WALK_LEFT;
            end
            
            is_walking_right: begin
                if (~ground)          next_state = FALL_RIGHT;
                else if (dig)         next_state = DIG_RIGHT;
                else if (bump_right)  next_state = WALK_LEFT;
                else                  next_state = WALK_RIGHT;
            end
            
            is_falling_left, is_falling_right: begin
                if (ground) begin
                    if (fall_timer >= 20) next_state = SPLAT;
                    else                 next_state = is_falling_left ? WALK_LEFT : WALK_RIGHT;
                end else begin
                    next_state = state;
                end
            end
            
            is_digging_left, is_digging_right: begin
                if (~ground) next_state = is_digging_left ? FALL_LEFT : FALL_RIGHT;
                else        next_state = state;
            end
            
            is_splat: next_state = SPLAT;
            
            default: next_state = WALK_LEFT;
        endcase
    end

    // Output assignments
    assign walk_left  = is_walking_left && ~is_digging_left;
    assign walk_right = is_walking_right && ~is_digging_right;
    assign aaah       = is_falling_left || is_falling_right;
    assign digging    = is_digging_left || is_digging_right;

endmodule