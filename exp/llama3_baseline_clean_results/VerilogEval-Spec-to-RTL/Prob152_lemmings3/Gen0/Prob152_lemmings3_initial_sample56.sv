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

parameter S_WALK_LEFT = 0;
parameter S_WALK_RIGHT = 1;
parameter S_FALL = 2;
parameter S_DIG = 3;

reg [1:0] state;
reg [1:0] next_state;
reg direction;
reg next_direction;

always @ (*) begin
    case (state)
        S_WALK_LEFT: begin
            if (!ground) begin
                next_state = S_FALL;
            end else if (dig && ground) begin
                next_state = S_DIG;
            end else if (bump_left) begin
                next_state = S_WALK_RIGHT;
            end else if (bump_right) begin
                next_state = S_WALK_LEFT;
            end else begin
                next_state = S_WALK_LEFT;
            end

            if (bump_right) begin
                next_direction = 1;
            end else begin
                next_direction = 0;
            end
        end
        S_WALK_RIGHT: begin
            if (!ground) begin
                next_state = S_FALL;
            end else if (dig && ground) begin
                next_state = S_DIG;
            end else if (bump_left) begin
                next_state = S_WALK_LEFT;
            end else if (bump_right) begin
                next_state = S_WALK_RIGHT;
            end else begin
                next_state = S_WALK_RIGHT;
            end

            if (bump_left) begin
                next_direction = 0;
            end else begin
                next_direction = 1;
            end
        end
        S_FALL: begin
            if (ground) begin
                next_state = (direction == 0)? S_WALK_LEFT : S_WALK_RIGHT;
            end else begin
                next_state = S_FALL;
            end

            next_direction = direction;
        end
        S_DIG: begin
            if (!ground) begin
                next_state = S_FALL;
            end else begin
                next_state = S_DIG;
            end

            next_direction = direction;
        end
        default: begin
            next_state = S_WALK_LEFT;
            next_direction = 0;
        end
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= S_WALK_LEFT;
        direction <= 0;
    end else begin
        state <= next_state;
        direction <= next_direction;
    end
end

always @ (*) begin
    case (state)
        S_WALK_LEFT: begin
            walk_left = 1;
            walk_right = 0;
            aaah = 0;
            digging = 0;
        end
        S_WALK_RIGHT: begin
            walk_left = 0;
            walk_right = 1;
            aaah = 0;
            digging = 0;
        end
        S_FALL: begin
            walk_left = 0;
            walk_right = 0;
            aaah = 1;
            digging = 0;
        end
        S_DIG: begin
            walk_left = 0;
            walk_right = 0;
            aaah = 0;
            digging = 1;
        end
        default: begin
            walk_left = 0;
            walk_right = 0;
            aaah = 0;
            digging = 0;
        end
    endcase
end

endmodule