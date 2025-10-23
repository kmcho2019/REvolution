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
typedef enum {
    IDLE_LEFT,
    IDLE_RIGHT,
    FALLING,
    DIGGING
} state_t;

// Initialize the state register
reg [1:0] state;

// Combinational logic to determine the next state
always @(posedge clk or posedge areset) begin
    if (areset) begin
        // Asynchronous reset: initialize to walking left
        state <= IDLE_LEFT;
        walk_left <= 1'b1;
        walk_right <= 1'b0;
        aaah <= 1'b0;
        digging <= 1'b0;
    end else begin
        case (state)
            IDLE_LEFT: begin
                if (!ground) begin
                    // If there's no ground, start falling
                    state <= FALLING;
                    walk_left <= 1'b0;
                    walk_right <= 1'b0;
                    aaah <= 1'b1;
                    digging <= 1'b0;
                end else if (dig) begin
                    // If we're told to dig, start digging
                    state <= DIGGING;
                    walk_left <= 1'b0;
                    walk_right <= 1'b0;
                    aaah <= 1'b0;
                    digging <= 1'b1;
                end else if (bump_left) begin
                    // If we're bumped on the left, switch to walking right
                    state <= IDLE_RIGHT;
                    walk_left <= 1'b0;
                    walk_right <= 1'b1;
                    aaah <= 1'b0;
                    digging <= 1'b0;
                end else begin
                    // Otherwise, stay walking left
                    state <= IDLE_LEFT;
                    walk_left <= 1'b1;
                    walk_right <= 1'b0;
                    aaah <= 1'b0;
                    digging <= 1'b0;
                end
            end
            IDLE_RIGHT: begin
                if (!ground) begin
                    // If there's no ground, start falling
                    state <= FALLING;
                    walk_left <= 1'b0;
                    walk_right <= 1'b0;
                    aaah <= 1'b1;
                    digging <= 1'b0;
                end else if (dig) begin
                    // If we're told to dig, start digging
                    state <= DIGGING;
                    walk_left <= 1'b0;
                    walk_right <= 1'b0;
                    aaah <= 1'b0;
                    digging <= 1'b1;
                end else if (bump_right) begin
                    // If we're bumped on the right, switch to walking left
                    state <= IDLE_LEFT;
                    walk_left <= 1'b1;
                    walk_right <= 1'b0;
                    aaah <= 1'b0;
                    digging <= 1'b0;
                end else begin
                    // Otherwise, stay walking right
                    state <= IDLE_RIGHT;
                    walk_left <= 1'b0;
                    walk_right <= 1'b1;
                    aaah <= 1'b0;
                    digging <= 1'b0;
                end
            end
            FALLING: begin
                if (ground) begin
                    // If we hit the ground, resume walking in the previous direction
                    if (bump_left || bump_right) begin
                        // If we're bumped, switch direction
                        if (bump_left) begin
                            state <= IDLE_RIGHT;
                            walk_left <= 1'b0;
                            walk_right <= 1'b1;
                        end else begin
                            state <= IDLE_LEFT;
                            walk_left <= 1'b1;
                            walk_right <= 1'b0;
                        end
                    end else if (state == IDLE_LEFT) begin
                        state <= IDLE_LEFT;
                        walk_left <= 1'b1;
                        walk_right <= 1'b0;
                    end else begin
                        state <= IDLE_RIGHT;
                        walk_left <= 1'b0;
                        walk_right <= 1'b1;
                    end
                    aaah <= 1'b0;
                    digging <= 1'b0;
                end else begin
                    // Otherwise, stay falling
                    state <= FALLING;
                    walk_left <= 1'b0;
                    walk_right <= 1'b0;
                    aaah <= 1'b1;
                    digging <= 1'b0;
                end
            end
            DIGGING: begin
                if (!ground) begin
                    // If we've reached the other side, start falling
                    state <= FALLING;
                    walk_left <= 1'b0;
                    walk_right <= 1'b0;
                    aaah <= 1'b1;
                    digging <= 1'b0;
                end else begin
                    // Otherwise, stay digging
                    state <= DIGGING;
                    walk_left <= 1'b0;
                    walk_right <= 1'b0;
                    aaah <= 1'b0;
                    digging <= 1'b1;
                end
            end
        endcase
    end
end

endmodule