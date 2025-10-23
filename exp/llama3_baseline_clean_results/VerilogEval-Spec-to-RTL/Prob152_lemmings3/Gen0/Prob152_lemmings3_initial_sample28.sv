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

reg [1:0] state, next_state;

// State encoding
parameter WALK_LEFT = 2'b00;
parameter WALK_RIGHT = 2'b01;
parameter FALL = 2'b10;
parameter DIG = 2'b11;

// Reset state
initial state = WALK_LEFT;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    next_state = state;
    walk_left = 0;
    walk_right = 0;
    aaah = 0;
    digging = 0;

    case (state)
        WALK_LEFT: begin
            if (~ground) begin
                next_state = FALL;
            end else if (dig) begin
                next_state = DIG;
            end else if (bump_left) begin
                next_state = WALK_RIGHT;
            end else if (bump_right) begin
                next_state = WALK_LEFT;
            end
            walk_left = 1;
        end
        WALK_RIGHT: begin
            if (~ground) begin
                next_state = FALL;
            end else if (dig) begin
                next_state = DIG;
            end else if (bump_left) begin
                next_state = WALK_LEFT;
            end else if (bump_right) begin
                next_state = WALK_LEFT;
            end
            walk_right = 1;
        end
        FALL: begin
            if (ground) begin
                if (state == FALL) begin
                    if (bump_left) begin
                        next_state = WALK_RIGHT;
                    end else if (bump_right) begin
                        next_state = WALK_LEFT;
                    end else if (~bump_left && ~bump_right) begin
                        next_state = WALK_LEFT;
                    end
                end
            end
            aaah = 1;
        end
        DIG: begin
            if (~ground) begin
                next_state = FALL;
            end else begin
                next_state = DIG;
            end
            digging = 1;
        end
    endcase
end

endmodule