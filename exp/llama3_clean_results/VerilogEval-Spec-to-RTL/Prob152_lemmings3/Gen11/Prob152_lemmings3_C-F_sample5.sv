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

// Define the top-level states
enum logic [1:0] {
    TOP_FALLING = 2'b00,
    TOP_WALKING = 2'b01,
    TOP_DIGGING = 2'b10
} top_state, next_top_state;

// Define the walking directions
enum logic [0:0] {
    DIRECTION_LEFT = 1'b0,
    DIRECTION_RIGHT = 1'b1
} direction, next_direction;

// Sequential logic for top-level state
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        top_state <= TOP_WALKING;
        direction <= DIRECTION_LEFT;
    end else begin
        top_state <= next_top_state;
        direction <= next_direction;
    end
end

// Combinational logic for next top-level state
always_comb begin
    next_top_state = top_state;
    next_direction = direction;

    case (top_state)
        TOP_FALLING: begin
            if (ground) begin
                next_top_state = TOP_WALKING;
            end
        end
        TOP_WALKING: begin
            if (!ground) begin
                next_top_state = TOP_FALLING;
            end else if (dig) begin
                next_top_state = TOP_DIGGING;
            end else if (bump_left && direction == DIRECTION_LEFT) begin
                next_direction = DIRECTION_RIGHT;
            end else if (bump_right && direction == DIRECTION_RIGHT) begin
                next_direction = DIRECTION_LEFT;
            end
        end
        TOP_DIGGING: begin
            if (!ground) begin
                next_top_state = TOP_FALLING;
            end
        end
    endcase
end

// Output logic
assign walk_left = (top_state == TOP_WALKING && direction == DIRECTION_LEFT);
assign walk_right = (top_state == TOP_WALKING && direction == DIRECTION_RIGHT);
assign aaah = (top_state == TOP_FALLING);
assign digging = (top_state == TOP_DIGGING);

endmodule