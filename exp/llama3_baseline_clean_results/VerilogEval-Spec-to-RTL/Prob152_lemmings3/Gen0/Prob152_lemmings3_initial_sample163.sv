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

// Define states
enum logic [2:0] {WALK_LEFT, WALK_RIGHT, FALLING, DIGGING_LEFT, DIGGING_RIGHT} state, next_state;

// Variable to track previous direction
reg prev_direction;

// Initialize states
initial state = WALK_LEFT;
initial prev_direction = 1'b0; // 0 for walking left, 1 for walking right

// Main logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
        prev_direction <= 1'b0; // Initialize to walking left
        walk_left <= 1'b1;
        walk_right <= 1'b0;
        aaah <= 1'b0;
        digging <= 1'b0;
    end else begin
        case (state)
            WALK_LEFT: begin
                if (ground == 1'b0) begin
                    state <= FALLING;
                    prev_direction <= 1'b0; // Store current direction (walking left)
                    walk_left <= 1'b0;
                    walk_right <= 1'b0;
                    aaah <= 1'b1;
                    digging <= 1'b0;
                end else if (dig == 1'b1) begin
                    state <= DIGGING_LEFT;
                    walk_left <= 1'b0;
                    walk_right <= 1'b0;
                    aaah <= 1'b0;
                    digging <= 1'b1;
                end else if (bump_left == 1'b1 || bump_right == 1'b1) begin
                    state <= WALK_RIGHT;
                    walk_left <= 1'b0;
                    walk_right <= 1'b1;
                    aaah <= 1'b0;
                    digging <= 1'b0;
                end else begin
                    state <= WALK_LEFT;
                    walk_left <= 1'b1;
                    walk_right <= 1'b0;
                    aaah <= 1'b0;
                    digging <= 1'b0;
                end
            end
            WALK_RIGHT: begin
                if (ground == 1'b0) begin
                    state <= FALLING;
                    prev_direction <= 1'b1; // Store current direction (walking right)
                    walk_left <= 1'b0;
                    walk_right <= 1'b0;
                    aaah <= 1'b1;
                    digging <= 1'b0;
                end else if (dig == 1'b1) begin
                    state <= DIGGING_RIGHT;
                    walk_left <= 1'b0;
                    walk_right <= 1'b0;
                    aaah <= 1'b0;
                    digging <= 1'b1;
                end else if (bump_left == 1'b1 || bump_right == 1'b1) begin
                    state <= WALK_LEFT;
                    walk_left <= 1'b1;
                    walk_right <= 1'b0;
                    aaah <= 1'b0;
                    digging <= 1'b0;
                end else begin
                    state <= WALK_RIGHT;
                    walk_left <= 1'b0;
                    walk_right <= 1'b1;
                    aaah <= 1'b0;
                    digging <= 1'b0;
                end
            end
            FALLING: begin
                if (ground == 1'b1) begin
                    if (prev_direction == 1'b0) begin
                        state <= WALK_LEFT;
                        walk_left <= 1'b1;
                        walk_right <= 1'b0;
                    end else begin
                        state <= WALK_RIGHT;
                        walk_left <= 1'b0;
                        walk_right <= 1'b1;
                    end
                    aaah <= 1'b0;
                    digging <= 1'b0;
                end else begin
                    state <= FALLING;
                    walk_left <= 1'b0;
                    walk_right <= 1'b0;
                    aaah <= 1'b1;
                    digging <= 1'b0;
                end
            end
            DIGGING_LEFT: begin
                if (ground == 1'b0) begin
                    state <= FALLING;
                    prev_direction <= 1'b0; // Store current direction (digging left)
                    walk_left <= 1'b0;
                    walk_right <= 1'b0;
                    aaah <= 1'b1;
                    digging <= 1'b0;
                end else begin
                    state <= DIGGING_LEFT;
                    walk_left <= 1'b0;
                    walk_right <= 1'b0;
                    aaah <= 1'b0;
                    digging <= 1'b1;
                end
            end
            DIGGING_RIGHT: begin
                if (ground == 1'b0) begin
                    state <= FALLING;
                    prev_direction <= 1'b1; // Store current direction (digging right)
                    walk_left <= 1'b0;
                    walk_right <= 1'b0;
                    aaah <= 1'b1;
                    digging <= 1'b0;
                end else begin
                    state <= DIGGING_RIGHT;
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