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

reg [2:0] state, next_state;
parameter WALK_LEFT = 3'b001, WALK_RIGHT = 3'b010, FALL = 3'b011, DIG_LEFT = 3'b100, DIG_RIGHT = 3'b101;

always @(*)
begin
    case (state)
        WALK_LEFT:
        begin
            if (!ground)
                next_state = FALL;
            else if (dig)
                next_state = DIG_LEFT;
            else if (bump_left)
                next_state = WALK_RIGHT;
            else if (bump_right)
                next_state = WALK_LEFT;
            else
                next_state = WALK_LEFT;
        end
        WALK_RIGHT:
        begin
            if (!ground)
                next_state = FALL;
            else if (dig)
                next_state = DIG_RIGHT;
            else if (bump_left)
                next_state = WALK_LEFT;
            else if (bump_right)
                next_state = WALK_LEFT;
            else
                next_state = WALK_RIGHT;
        end
        FALL:
        begin
            if (ground)
            begin
                if (state == DIG_LEFT)
                    next_state = WALK_LEFT;
                else if (state == DIG_RIGHT)
                    next_state = WALK_RIGHT;
                else if (state == WALK_LEFT)
                    next_state = WALK_LEFT;
                else if (state == WALK_RIGHT)
                    next_state = WALK_RIGHT;
            end
            else
                next_state = FALL;
        end
        DIG_LEFT:
        begin
            if (!ground)
                next_state = FALL;
            else
                next_state = DIG_LEFT;
        end
        DIG_RIGHT:
        begin
            if (!ground)
                next_state = FALL;
            else
                next_state = DIG_RIGHT;
        end
        default:
            next_state = WALK_LEFT;
    endcase
end

always @(posedge clk or posedge areset)
begin
    if (areset)
        state <= WALK_LEFT;
    else
        state <= next_state;
end

always @(*)
begin
    case (state)
        WALK_LEFT:
        begin
            walk_left = 1;
            walk_right = 0;
            aaah = 0;
            digging = 0;
        end
        WALK_RIGHT:
        begin
            walk_left = 0;
            walk_right = 1;
            aaah = 0;
            digging = 0;
        end
        FALL:
        begin
            walk_left = 0;
            walk_right = 0;
            aaah = 1;
            digging = 0;
        end
        DIG_LEFT:
        begin
            walk_left = 0;
            walk_right = 0;
            aaah = 0;
            digging = 1;
        end
        DIG_RIGHT:
        begin
            walk_left = 0;
            walk_right = 0;
            aaah = 0;
            digging = 1;
        end
        default:
        begin
            walk_left = 1;
            walk_right = 0;
            aaah = 0;
            digging = 0;
        end
    endcase
end

endmodule