module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah
);

reg [1:0] state, next_state;

// State Encoding
parameter LEFT = 2'b00;
parameter RIGHT = 2'b01;
parameter FALLING = 2'b10;

always @(*) begin
    case(state)
        LEFT: begin
            if (~ground) begin
                next_state = FALLING;
            end else if (bump_left) begin
                next_state = RIGHT;
            end else if (bump_right) begin
                next_state = RIGHT;
            end else begin
                next_state = LEFT;
            end
        end
        RIGHT: begin
            if (~ground) begin
                next_state = FALLING;
            end else if (bump_left) begin
                next_state = LEFT;
            end else if (bump_right) begin
                next_state = LEFT;
            end else begin
                next_state = RIGHT;
            end
        end
        FALLING: begin
            if (ground) begin
                next_state = (bump_left || bump_right) ? (state == FALLING ? LEFT : RIGHT) : (state == FALLING ? LEFT : RIGHT);
                if (bump_left && bump_right) begin
                    next_state = LEFT;
                end else if (bump_left) begin
                    next_state = RIGHT;
                end else if (bump_right) begin
                    next_state = LEFT;
                end else begin
                    next_state = state == LEFT ? LEFT : RIGHT;
                end
            end else begin
                next_state = FALLING;
            end
        end
        default: begin
            next_state = LEFT;
        end
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= LEFT;
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case(state)
        LEFT: begin
            walk_left = 1;
            walk_right = 0;
            aaah = 0;
        end
        RIGHT: begin
            walk_left = 0;
            walk_right = 1;
            aaah = 0;
        end
        FALLING: begin
            walk_left = 0;
            walk_right = 0;
            aaah = 1;
        end
        default: begin
            walk_left = 0;
            walk_right = 0;
            aaah = 0;
        end
    endcase
end

endmodule