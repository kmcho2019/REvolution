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

    // Consistent 3-bit state encoding
    localparam WALK_LEFT  = 3'b000;
    localparam WALK_RIGHT = 3'b001;
    localparam FALL       = 3'b010;
    localparam DIG        = 3'b011;
    localparam SPLATTER   = 3'b100;

    reg [2:0] state, next_state;
    reg [4:0] fall_timer;
    reg direction;  // 0=left, 1=right

    // State transition logic
    always @(*) begin
        case (state)
            WALK_LEFT: begin
                if (~ground)          next_state = FALL;
                else if (dig)          next_state = DIG;
                else if (bump_left)    next_state = WALK_RIGHT;
                else                   next_state = WALK_LEFT;
            end
            WALK_RIGHT: begin
                if (~ground)          next_state = FALL;
                else if (dig)         next_state = DIG;
                else if (bump_right)  next_state = WALK_LEFT;
                else                  next_state = WALK_RIGHT;
            end
            FALL: begin
                if (ground) begin
                    if (fall_timer > 20) next_state = SPLATTER;
                    else                next_state = direction ? WALK_RIGHT : WALK_LEFT;
                end
                else                    next_state = FALL;
            end
            DIG: begin
                if (~ground)          next_state = FALL;
                else                  next_state = DIG;
            end
            SPLATTER:                 next_state = SPLATTER;
            default:                  next_state = WALK_LEFT;
        endcase
    end

    // Sequential logic for state and direction
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            direction <= 0;
            fall_timer <= 0;
        end else begin
            state <= next_state;
            
            // Update direction only in walking states
            if (next_state == WALK_LEFT)  direction <= 0;
            if (next_state == WALK_RIGHT) direction <= 1;
            
            // Fall timer logic
            if (state == FALL && ~ground) begin
                fall_timer <= fall_timer + 1;
            end else begin
                fall_timer <= 0;
            end
        end
    end

    // Output assignments
    assign walk_left = (state == WALK_LEFT) || (state == DIG && ~direction);
    assign walk_right = (state == WALK_RIGHT) || (state == DIG && direction);
    assign aaah = (state == FALL);
    assign digging = (state == DIG);

endmodule