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
    end else begin
        state <= next_state;
        walk_dir <= next_walk_dir;
    end
end

always @(*) begin
    // Default values
    next_state = state;
    next_walk_dir = walk_dir;
    walk_left = 1'b0;
    walk_right = 1'b0;
    aaah = 1'b0;
    digging = 1'b0;

    case (state)
        WALK_LEFT: begin
            walk_left = 1'b1;
            if (ground == 1'b0) begin
                next_state = FALLING;
            end else if (dig == 1'b1) begin
                next_state = DIGGING;
            end else if (bump_left == 1'b1 || bump_right == 1'b1) begin
                next_state = WALK_RIGHT;
                next_walk_dir = 1'b1;
            end
        end
        WALK_RIGHT: begin
            walk_right = 1'b1;
            if (ground == 1'b0) begin
                next_state = FALLING;
            end else if (dig == 1'b1) begin
                next_state = DIGGING;
            end else if (bump_left == 1'b1 || bump_right == 1'b1) begin
                next_state = WALK_LEFT;
                next_walk_dir = 0;
            end
        end
        FALLING: begin
            aaah = 1'b1;
            if (ground == 1'b1) begin
                next_state = walk_dir? WALK_RIGHT : WALK_LEFT;
            end
        end
        DIGGING: begin
            digging = 1'b1;
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