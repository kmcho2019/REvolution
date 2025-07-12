module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);

// Define the states
enum logic [2:0] {
    walking_left = 3'b001,
    walking_right = 3'b010,
    falling = 3'b011,
    digging_left = 3'b100,
    digging_right = 3'b101
} state, next_state;

// Initialize the state
always @(posedge areset or posedge clk) begin
    if (areset) begin
        state <= walking_left;
    end else begin
        state <= next_state;
    end
end

// Determine the next state
always @(*) begin
    case (state)
        walking_left: begin
            if (!ground) begin
                next_state <= falling;
            end else if (dig) begin
                next_state <= digging_left;
            end else if (bump_left) begin
                next_state <= walking_right;
            end else if (bump_right) begin
                next_state <= walking_left;
            end else begin
                next_state <= walking_left;
            end
        end
        walking_right: begin
            if (!ground) begin
                next_state <= falling;
            end else if (dig) begin
                next_state <= digging_right;
            end else if (bump_left) begin
                next_state <= walking_right;
            end else if (bump_right) begin
                next_state <= walking_left;
            end else begin
                next_state <= walking_right;
            end
        end
        falling: begin
            if (ground) begin
                if (state == falling) begin
                    // we don't know the original direction when falling
                    // we assume the original direction is the last state before falling
                    // so we need to keep track of the last state before falling
                    // we can use two extra variables to keep track of the last state
                    reg [2:0] last_state_before_falling;
                    always @(posedge clk) begin
                        if (state == falling) begin
                            if (last_state_before_falling == walking_left) begin
                                next_state <= walking_left;
                            end else if (last_state_before_falling == walking_right) begin
                                next_state <= walking_right;
                            end
                        end
                    end
                end
            end else begin
                next_state <= falling;
            end
        end
        digging_left: begin
            if (!ground) begin
                next_state <= falling;
            end else begin
                next_state <= digging_left;
            end
        end
        digging_right: begin
            if (!ground) begin
                next_state <= falling;
            end else begin
                next_state <= digging_right;
            end
        end
        default: begin
            next_state <= walking_left;
        end
    endcase
end

// Assign the outputs
always @(*) begin
    case (state)
        walking_left: begin
            walk_left <= 1;
            walk_right <= 0;
            aaah <= 0;
            digging <= 0;
        end
        walking_right: begin
            walk_left <= 0;
            walk_right <= 1;
            aaah <= 0;
            digging <= 0;
        end
        falling: begin
            walk_left <= 0;
            walk_right <= 0;
            aaah <= 1;
            digging <= 0;
        end
        digging_left: begin
            walk_left <= 0;
            walk_right <= 0;
            aaah <= 0;
            digging <= 1;
        end
        digging_right: begin
            walk_left <= 0;
            walk_right <= 0;
            aaah <= 0;
            digging <= 1;
        end
        default: begin
            walk_left <= 0;
            walk_right <= 0;
            aaah <= 0;
            digging <= 0;
        end
    endcase
end

endmodule