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
parameter WALK_LEFT = 2'b00;
parameter WALK_RIGHT = 2'b01;
parameter FALLING = 2'b10;
parameter DIGGING = 2'b11;

reg [1:0] state, next_state;
reg walk_dir; // 0 for left, 1 for right
reg next_walk_dir;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALK_LEFT;
        walk_dir <= 0; // Initially walk left
        walk_left <= 1'b1;
        walk_right <= 1'b0;
        aaah <= 1'b0;
        digging <= 1'b0;
    end else begin
        state <= next_state;
        walk_dir <= next_walk_dir;
        walk_left <= (next_state == WALK_LEFT || (next_state == FALLING && walk_dir == 0)) ? 1'b1 : 1'b0;
        walk_right <= (next_state == WALK_RIGHT || (next_state == FALLING && walk_dir == 1)) ? 1'b1 : 1'b0;
        aaah <= (next_state == FALLING) ? 1'b1 : 1'b0;
        digging <= (next_state == DIGGING) ? 1'b1 : 1'b0;
    end
end

always @(*) begin
    // Default values
    next_state = state;
    next_walk_dir = walk_dir;

    case (state)
        WALK_LEFT: begin
            if (ground == 1'b0) begin
                next_state = FALLING;
            end else if (dig == 1'b1) begin
                next_state = DIGGING;
            end else if (bump_left == 1'b1 || (bump_left == 1'b1 && bump_right == 1'b1)) begin
                next_state = WALK_RIGHT;
                next_walk_dir = 1'b1;
            end else if (bump_right == 1'b1) begin
                next_state = WALK_LEFT;
                next_walk_dir = 0; // Already walking left
            end
        end
        WALK_RIGHT: begin
            if (ground == 1'b0) begin
                next_state = FALLING;
            end else if (dig == 1'b1) begin
                next_state = DIGGING;
            end else if (bump_right == 1'b1 || (bump_left == 1'b1 && bump_right == 1'b1)) begin
                next_state = WALK_LEFT;
                next_walk_dir = 0;
            end else if (bump_left == 1'b1) begin
                next_state = WALK_RIGHT;
                next_walk_dir = 1'b1; // Already walking right
            end
        end
        FALLING: begin
            if (ground == 1'b1) begin
                next_state = (walk_dir == 1'b0) ? WALK_LEFT : WALK_RIGHT;
            end
        end
        DIGGING: begin
            if (ground == 1'b0) begin
                next_state = FALLING;
            end
        end
        default: begin
            next_state = WALK_LEFT; // Default to walking left
            next_walk_dir = 0;
        end
    endcase
end

endmodule