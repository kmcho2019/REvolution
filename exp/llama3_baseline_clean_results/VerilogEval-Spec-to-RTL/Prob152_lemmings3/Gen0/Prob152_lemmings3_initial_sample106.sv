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

// Define the states
localparam WALK_LEFT = 2'b00;
localparam WALK_RIGHT = 2'b01;
localparam FALLING = 2'b10;
localparam DIGGING = 2'b11;

always @(*) begin
    case (state)
        WALK_LEFT: begin
            if (!ground) begin
                next_state = FALLING;
                walk_left = 0;
                walk_right = 0;
                aaah = 1;
                digging = 0;
            end else if (dig) begin
                next_state = DIGGING;
                walk_left = 0;
                walk_right = 0;
                aaah = 0;
                digging = 1;
            end else if (bump_left) begin
                next_state = WALK_RIGHT;
                walk_left = 0;
                walk_right = 1;
                aaah = 0;
                digging = 0;
            end else if (bump_right) begin
                next_state = WALK_LEFT;
                walk_left = 1;
                walk_right = 0;
                aaah = 0;
                digging = 0;
            end else begin
                next_state = WALK_LEFT;
                walk_left = 1;
                walk_right = 0;
                aaah = 0;
                digging = 0;
            end
        end

        WALK_RIGHT: begin
            if (!ground) begin
                next_state = FALLING;
                walk_left = 0;
                walk_right = 0;
                aaah = 1;
                digging = 0;
            end else if (dig) begin
                next_state = DIGGING;
                walk_left = 0;
                walk_right = 0;
                aaah = 0;
                digging = 1;
            end else if (bump_left) begin
                next_state = WALK_LEFT;
                walk_left = 1;
                walk_right = 0;
                aaah = 0;
                digging = 0;
            end else if (bump_right) begin
                next_state = WALK_RIGHT;
                walk_left = 0;
                walk_right = 1;
                aaah = 0;
                digging = 0;
            end else begin
                next_state = WALK_RIGHT;
                walk_left = 0;
                walk_right = 1;
                aaah = 0;
                digging = 0;
            end
        end

        FALLING: begin
            if (ground) begin
                if (state == FALLING && (bump_left || bump_right)) begin
                    if (bump_left) begin
                        next_state = WALK_RIGHT;
                    end else if (bump_right) begin
                        next_state = WALK_LEFT;
                    end else begin
                        next_state = WALK_LEFT;
                    end
                end else if (state == FALLING && (state == DIGGING)) begin
                    next_state = WALK_LEFT;
                end else if (state == FALLING) begin
                    if (bump_left) begin
                        next_state = WALK_RIGHT;
                    end else if (bump_right) begin
                        next_state = WALK_LEFT;
                    end else if (state == WALK_LEFT) begin
                        next_state = WALK_LEFT;
                    end else if (state == WALK_RIGHT) begin
                        next_state = WALK_RIGHT;
                    end else begin
                        next_state = WALK_LEFT;
                    end
                end
                walk_left = (next_state == WALK_LEFT) ? 1 : 0;
                walk_right = (next_state == WALK_RIGHT) ? 1 : 0;
                aaah = 0;
                digging = 0;
            end else begin
                next_state = FALLING;
                walk_left = 0;
                walk_right = 0;
                aaah = 1;
                digging = 0;
            end
        end

        DIGGING: begin
            if (!ground) begin
                next_state = FALLING;
                walk_left = 0;
                walk_right = 0;
                aaah = 1;
                digging = 0;
            end else begin
                next_state = DIGGING;
                walk_left = 0;
                walk_right = 0;
                aaah = 0;
                digging = 1;
            end
        end

        default: begin
            next_state = WALK_LEFT;
            walk_left = 1;
            walk_right = 0;
            aaah = 0;
            digging = 0;
        end
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
    end else begin
        state <= next_state;
    end
end

endmodule