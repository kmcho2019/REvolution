module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    output walk_left,
    output walk_right,
    output aaah
);

// Define the states of the state machine
typedef enum logic [1:0] {
    walking_left,
    walking_right,
    falling
} state;

// Declare the current and next states
state current_state, next_state;

// Always block to handle the asynchronous reset
always @(posedge areset or posedge clk) begin
    if (areset) begin
        current_state <= walking_left;
    end else begin
        current_state <= next_state;
    end
end

// Always comb block to determine the next state
always_comb begin
    case (current_state)
        walking_left: begin
            if (bump_left) begin
                next_state = walking_right;
            end else if (bump_right) begin
                next_state = walking_right;
            end else if (!ground) begin
                next_state = falling;
            end else begin
                next_state = walking_left;
            end
        end
        walking_right: begin
            if (bump_left) begin
                next_state = walking_left;
            end else if (bump_right) begin
                next_state = walking_left;
            end else if (!ground) begin
                next_state = falling;
            end else begin
                next_state = walking_right;
            end
        end
        falling: begin
            if (ground) begin
                if (bump_left && bump_right) begin
                    // do nothing
                end else if (bump_left) begin
                    next_state = walking_right;
                end else if (bump_right) begin
                    next_state = walking_left;
                end else if (current_state == falling) begin
                    if (next_state == walking_left) begin
                        next_state = walking_left;
                    end else begin
                        next_state = walking_right;
                    end
                end else begin
                    if (current_state == walking_left) begin
                        next_state = walking_left;
                    end else begin
                        next_state = walking_right;
                    end
                end
            end else begin
                next_state = falling;
            end
        end
    endcase
end

// Always comb block to determine the output signals
always_comb begin
    case (current_state)
        walking_left: begin
            walk_left = 1;
            walk_right = 0;
            aaah = 0;
        end
        walking_right: begin
            walk_left = 0;
            walk_right = 1;
            aaah = 0;
        end
        falling: begin
            walk_left = 0;
            walk_right = 0;
            aaah = 1;
        end
    endcase
end

endmodule