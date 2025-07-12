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
reg prev_direction;

parameter WALK_LEFT = 2'b00;
parameter WALK_RIGHT = 2'b01;
parameter FALL = 2'b10;
parameter DIG = 2'b11;

always @(*) begin
    case (state)
        WALK_LEFT: begin
            if (!ground) begin
                next_state = FALL;
            end else if (dig) begin
                next_state = DIG;
            end else if (bump_left) begin
                next_state = WALK_RIGHT;
            end else if (bump_right) begin
                next_state = WALK_LEFT;
            end else begin
                next_state = WALK_LEFT;
            end
        end
        WALK_RIGHT: begin
            if (!ground) begin
                next_state = FALL;
            end else if (dig) begin
                next_state = DIG;
            end else if (bump_left) begin
                next_state = WALK_LEFT;
            end else if (bump_right) begin
                next_state = WALK_LEFT;
            end else begin
                next_state = WALK_RIGHT;
            end
        end
        FALL: begin
            if (ground) begin
                next_state = prev_direction ? WALK_LEFT : WALK_RIGHT;
            end else begin
                next_state = FALL;
            end
        end
        DIG: begin
            if (!ground) begin
                next_state = FALL;
            end else begin
                next_state = DIG;
            end
        end
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
        prev_direction <= 1'b1;
        walk_left <= 1'b1;
        walk_right <= 1'b0;
        aaah <= 1'b0;
        digging <= 1'b0;
    end else begin
        state <= next_state;
        if (state == WALK_LEFT) begin
            prev_direction <= 1'b1;
        end else if (state == WALK_RIGHT) begin
            prev_direction <= 1'b0;
        end
        if (state == WALK_LEFT) begin
            walk_left <= 1'b1;
            walk_right <= 1'b0;
        end else if (state == WALK_RIGHT) begin
            walk_left <= 1'b0;
            walk_right <= 1'b1;
        end else begin
            walk_left <= 1'b0;
            walk_right <= 1'b0;
        end
        if (state == FALL) begin
            aaah <= 1'b1;
        end else begin
            aaah <= 1'b0;
        end
        if (state == DIG) begin
            digging <= 1'b1;
        end else begin
            digging <= 1'b0;
        end
    end
end

endmodule