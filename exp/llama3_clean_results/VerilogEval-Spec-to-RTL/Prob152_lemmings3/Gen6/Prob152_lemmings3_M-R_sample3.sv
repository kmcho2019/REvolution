module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);

// Define the states
enum logic {
    WALK_LEFT = 1'b0,
    WALK_RIGHT = 1'b1
} walk_state, next_walk_state;

// Store the original direction before falling
reg falling;
reg digging_state;

// Sequential logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        walk_state <= WALK_LEFT;
        falling <= 1'b0;
        digging_state <= 1'b0;
    end else begin
        walk_state <= next_walk_state;
        falling <= (falling && !ground) || (!ground && (walk_state == WALK_LEFT || walk_state == WALK_RIGHT));
        digging_state <= (digging_state && dig && ground) || (dig && ground && (walk_state == WALK_LEFT || walk_state == WALK_RIGHT));
    end
end

// Combinational logic for next state
always_comb begin
    next_walk_state = walk_state;

    if (falling) begin
        next_walk_state = walk_state;
    end else if (digging_state) begin
        next_walk_state = walk_state;
    end else if (bump_left && !ground) begin
        next_walk_state = walk_state;
    end else if (bump_right && !ground) begin
        next_walk_state = walk_state;
    end else if (bump_left) begin
        next_walk_state = WALK_RIGHT;
    end else if (bump_right) begin
        next_walk_state = WALK_LEFT;
    end
end

// Combinational logic for outputs
assign walk_left = (walk_state == WALK_LEFT) && !falling && !digging_state;
assign walk_right = (walk_state == WALK_RIGHT) && !falling && !digging_state;
assign aaah = falling;
assign digging = digging_state;

endmodule