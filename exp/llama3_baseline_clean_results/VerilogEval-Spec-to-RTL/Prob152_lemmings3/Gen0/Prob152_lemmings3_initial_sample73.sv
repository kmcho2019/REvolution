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

// Define the states
enum logic [2:0] {
    walking_left,
    walking_right,
    falling,
    digging_left,
    digging_right
} state, next_state;

// State register
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= walking_left;
    end else begin
        state <= next_state;
    end
end

// Next state logic
always_comb begin
    case (state)
        walking_left: begin
            if (!ground) begin
                next_state = falling;
            end else if (dig) begin
                next_state = digging_left;
            end else if (bump_left) begin
                next_state = walking_right;
            end else begin
                next_state = walking_left;
            end
        end
        walking_right: begin
            if (!ground) begin
                next_state = falling;
            end else if (dig) begin
                next_state = digging_right;
            end else if (bump_right) begin
                next_state = walking_left;
            end else begin
                next_state = walking_right;
            end
        end
        falling: begin
            if (ground) begin
                // If falling and ground reappears, resume walking in the same direction
                if (bump_left && bump_right) begin
                    // If bumped on both sides, switch direction
                    if (state == walking_left) begin
                        next_state = walking_right;
                    end else begin
                        next_state = walking_left;
                    end
                end else if (bump_left) begin
                    next_state = walking_right;
                end else if (bump_right) begin
                    next_state = walking_left;
                end else if (state == walking_left) begin
                    next_state = walking_left;
                end else begin
                    next_state = walking_right;
                end
            end else begin
                next_state = falling;
            end
        end
        digging_left: begin
            if (!ground) begin
                next_state = falling;
            end else begin
                next_state = digging_left;
            end
        end
        digging_right: begin
            if (!ground) begin
                next_state = falling;
            end else begin
                next_state = digging_right;
            end
        end
        default: next_state = walking_left;
    endcase
end

// Output logic
always_comb begin
    case (state)
        walking_left: begin
            walk_left = 1;
            walk_right = 0;
            aaah = 0;
            digging = 0;
        end
        walking_right: begin
            walk_left = 0;
            walk_right = 1;
            aaah = 0;
            digging = 0;
        end
        falling: begin
            walk_left = 0;
            walk_right = 0;
            aaah = 1;
            digging = 0;
        end
        digging_left: begin
            walk_left = 1;
            walk_right = 0;
            aaah = 0;
            digging = 1;
        end
        digging_right: begin
            walk_left = 0;
            walk_right = 1;
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