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

// Define the states and walking directions using encoded variables
enum logic [1:0] {
    FALLING = 2'b00,
    WALKING = 2'b01,
    DIGGING = 2'b10
} state, next_state;

enum logic {
    LEFT = 1'b0,
    RIGHT = 1'b1
} walk_direction, next_walk_direction;

// Sequential logic with asynchronous reset
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALKING;
        walk_direction <= LEFT;
    end else begin
        state <= next_state;
        walk_direction <= next_walk_direction;
    end
end

// Combinational logic for next state and walking direction
always_comb begin
    next_state = state;
    next_walk_direction = walk_direction;

    case (state)
        WALKING: begin
            if (!ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING;
            end else if (bump_left || bump_right) begin
                next_walk_direction = ~walk_direction; // Simplified direction switching
            end
        end
        FALLING: begin
            if (ground) begin
                next_state = WALKING;
            end
        end
        DIGGING: begin
            if (!ground) begin
                next_state = FALLING;
            end
        end
    endcase
end

// Output logic with reduced switching activity
always_comb begin
    walk_left = 1'b0;
    walk_right = 1'b0;
    aaah = 1'b0;
    digging = 1'b0;

    case (state)
        WALKING: begin
            if (walk_direction == LEFT) begin
                walk_left = 1'b1;
            end else begin
                walk_right = 1'b1;
            end
        end
        FALLING: begin
            aaah = 1'b1;
        end
        DIGGING: begin
            digging = 1'b1;
        end
    endcase
end

endmodule