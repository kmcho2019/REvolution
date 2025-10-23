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

    // Encoded state representation
    parameter [2:0] 
        LEFT_WALK  = 3'b000,
        RIGHT_WALK = 3'b001,
        LEFT_FALL  = 3'b010,
        RIGHT_FALL = 3'b011,
        LEFT_DIG   = 3'b100,
        RIGHT_DIG  = 3'b101,
        SPLAT      = 3'b110;
    reg [2:0] state, next_state;

    // Event queue (priority encoded)
    wire event_fall = ~ground;
    wire event_dig = dig & ground & (state[1:0] == 2'b00); // Only in WALK states
    wire event_bump = (bump_left | bump_right) & (state[1:0] == 2'b00); // Only in WALK states

    // Fall timeout tracking
    reg [4:0] fall_timer;
    wire timeout = (fall_timer > 20);

    // State transition logic
    always @(*) begin
        case (state)
            LEFT_WALK: begin
                if (event_fall)       next_state = LEFT_FALL;
                else if (event_dig)   next_state = LEFT_DIG;
                else if (event_bump) next_state = (bump_left) ? RIGHT_WALK : LEFT_WALK;
                else                 next_state = LEFT_WALK;
            end
            RIGHT_WALK: begin
                if (event_fall)      next_state = RIGHT_FALL;
                else if (event_dig)   next_state = RIGHT_DIG;
                else if (event_bump)  next_state = (bump_right) ? LEFT_WALK : RIGHT_WALK;
                else                 next_state = RIGHT_WALK;
            end
            LEFT_FALL, RIGHT_FALL: begin
                if (ground) begin
                    if (timeout)     next_state = SPLAT;
                    else             next_state = (state == LEFT_FALL) ? LEFT_WALK : RIGHT_WALK;
                end else begin
                    next_state = state;
                end
            end
            LEFT_DIG, RIGHT_DIG: begin
                if (~ground)         next_state = (state == LEFT_DIG) ? LEFT_FALL : RIGHT_FALL;
                else                 next_state = state;
            end
            SPLAT:                   next_state = SPLAT;
            default:                 next_state = LEFT_WALK;
        endcase
    end

    // Sequential logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= LEFT_WALK;
            fall_timer <= 0;
        end else begin
            state <= next_state;
            
            // Update fall timer
            if ((state == LEFT_FALL) || (state == RIGHT_FALL)) begin
                if (~ground) begin
                    if (fall_timer < 31) fall_timer <= fall_timer + 1;
                end else begin
                    fall_timer <= 0;
                end
            end else begin
                fall_timer <= 0;
            end
        end
    end

    // Output logic
    assign walk_left = (state == LEFT_WALK);
    assign walk_right = (state == RIGHT_WALK);
    assign aaah = (state == LEFT_FALL) || (state == RIGHT_FALL);
    assign digging = (state == LEFT_DIG) || (state == RIGHT_DIG);

endmodule