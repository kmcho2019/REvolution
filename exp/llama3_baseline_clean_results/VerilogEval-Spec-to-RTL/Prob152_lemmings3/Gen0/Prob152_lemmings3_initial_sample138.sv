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

// Define states
parameter WALK_LEFT = 2'b00;
parameter WALK_RIGHT = 2'b01;
parameter FALLING = 2'b10;
parameter DIGGING = 2'b11;

reg [1:0] state, next_state;

// Output logic
always @(posedge clk) begin
    if (areset) begin
        state <= WALK_LEFT;
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case (state)
        WALK_LEFT: begin
            walk_left = 1'b1;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
            if (ground == 1'b0) begin
                next_state = FALLING;
            end else if (dig == 1'b1) begin
                next_state = DIGGING;
            end else if (bump_left == 1'b1) begin
                next_state = WALK_RIGHT;
            end else if (bump_right == 1'b1) begin
                next_state = WALK_LEFT;
            end else begin
                next_state = WALK_LEFT;
            end
        end
        WALK_RIGHT: begin
            walk_left = 1'b0;
            walk_right = 1'b1;
            aaah = 1'b0;
            digging = 1'b0;
            if (ground == 1'b0) begin
                next_state = FALLING;
            end else if (dig == 1'b1) begin
                next_state = DIGGING;
            end else if (bump_left == 1'b1) begin
                next_state = WALK_LEFT;
            end else if (bump_right == 1'b1) begin
                next_state = WALK_RIGHT;
            end else begin
                next_state = WALK_RIGHT;
            end
        end
        FALLING: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b1;
            digging = 1'b0;
            if (ground == 1'b1) begin
                if (bump_left == 1'b1 && bump_right == 1'b1) begin
                    next_state = WALK_LEFT;
                end else if (bump_left == 1'b1) begin
                    next_state = WALK_RIGHT;
                end else if (bump_right == 1'b1) begin
                    next_state = WALK_LEFT;
                end else if (state == FALLING && dig == 1'b1) begin
                    next_state = WALK_LEFT;
                end else if (state == FALLING && dig == 1'b0) begin
                    next_state = WALK_LEFT;
                end else begin
                    if (bump_left == 1'b0 && bump_right == 1'b0) begin
                        if (state == FALLING && dig == 1'b1) begin
                            next_state = WALK_LEFT;
                        end else if (state == FALLING && dig == 1'b0) begin
                            next_state = WALK_LEFT;
                        end else if (state == FALLING && dig == 1'b0 && bump_left == 1'b0 && bump_right == 1'b0) begin
                            next_state = WALK_LEFT;
                        end else begin
                            if (state == FALLING && dig == 1'b0 && bump_left == 1'b0 && bump_right == 1'b0) begin
                                next_state = WALK_LEFT;
                            end else begin
                                next_state = WALK_LEFT;
                            end
                        end
                    end else begin
                        next_state = WALK_LEFT;
                    end
                end
            end else begin
                next_state = FALLING;
            end
        end
        DIGGING: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b1;
            if (ground == 1'b0) begin
                next_state = FALLING;
            end else begin
                next_state = DIGGING;
            end
        end
        default: begin
            walk_left = 1'b0;
            walk_right = 1'b0;
            aaah = 1'b0;
            digging = 1'b0;
            next_state = WALK_LEFT;
        end
    endcase
end

endmodule