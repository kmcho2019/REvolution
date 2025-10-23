module TopModule(
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

parameter S_WALK_LEFT = 2'b00;
parameter S_WALK_RIGHT = 2'b01;
parameter S_FALL = 2'b10;
parameter S_DIG = 2'b11;

reg [1:0] state;
reg [1:0] next_state;
reg walk_direction;

always @(*) begin
    case (state)
        S_WALK_LEFT: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
            if (~ground) begin
                next_state = S_FALL;
            end else if (dig) begin
                next_state = S_DIG;
            end else if (bump_left) begin
                next_state = S_WALK_RIGHT;
            end else if (bump_right) begin
                next_state = S_WALK_LEFT;
            end else begin
                next_state = S_WALK_LEFT;
            end
        end
        S_WALK_RIGHT: begin
            walk_left = 1'b0;
            walk_right = 1'b1;
            aaah = 1'b0;
            digging = 1'b0;
            if (~ground) begin
                next_state = S_FALL;
            end else if (dig) begin
                next_state = S_DIG;
            end else if (bump_left) begin
                next_state = S_WALK_LEFT;
            end else if (bump_right) begin
                next_state = S_WALK_RIGHT;
            end else begin
                next_state = S_WALK_RIGHT;
            end
        end
        S_FALL: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
            digging = 1'b0;
            if (ground) begin
                next_state = walk_direction? S_WALK_LEFT : S_WALK_RIGHT;
            end else begin
                next_state = S_FALL;
            end
        end
        S_DIG: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b1;
            if (~ground) begin
                next_state = S_FALL;
            end else begin
                next_state = S_DIG;
            end
        end
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state = S_WALK_LEFT;
        walk_direction = 1'b0;
    end else begin
        case (state)
            S_WALK_LEFT: begin
                walk_direction = 1'b0;
            end
            S_WALK_RIGHT: begin
                walk_direction = 1'b1;
            end
            S_FALL: begin
                // Do nothing
            end
            S_DIG: begin
                // Do nothing
            end
        endcase
        state = next_state;
    end
end

endmodule