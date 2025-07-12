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

// Define the outer layer states
enum logic [1:0] {
    OUTER_WALKING = 2'b00,
    OUTER_FALLING = 2'b01,
    OUTER_DIGGING = 2'b10,
    OUTER_IDLE = 2'b11
} outer_state, outer_next_state;

// Define the inner layer states
enum logic {
    INNER_WALK_LEFT = 1'b0,
    INNER_WALK_RIGHT = 1'b1
} inner_state, inner_next_state;

// Define the previous walking direction
reg prev_walk_direction;

// Assign initial states
initial outer_state = OUTER_WALKING;
initial inner_state = INNER_WALK_LEFT;

// Sequential logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        outer_state <= OUTER_WALKING;
        inner_state <= INNER_WALK_LEFT;
        prev_walk_direction <= INNER_WALK_LEFT;
    end else begin
        outer_state <= outer_next_state;
        inner_state <= inner_next_state;
    end
end

// Combinational logic
always_comb begin
    outer_next_state = outer_state;
    inner_next_state = inner_state;

    walk_left = 1'b0;
    walk_right = 1'b0;
    aaah = 1'b0;
    digging = 1'b0;

    case (outer_state)
        OUTER_WALKING: begin
            if (inner_state == INNER_WALK_LEFT) begin
                walk_left = 1'b1;
            end else begin
                walk_right = 1'b1;
            end

            if (!ground) begin
                outer_next_state = OUTER_FALLING;
                prev_walk_direction = inner_state;
            end else if (dig) begin
                outer_next_state = OUTER_DIGGING;
            end else if (bump_left || bump_right) begin
                inner_next_state = (inner_state == INNER_WALK_LEFT) ? INNER_WALK_RIGHT : INNER_WALK_LEFT;
            end
        end
        OUTER_FALLING: begin
            aaah = 1'b1;
            if (ground) begin
                outer_next_state = OUTER_WALKING;
                inner_next_state = prev_walk_direction;
            end
        end
        OUTER_DIGGING: begin
            digging = 1'b1;
            if (!ground) begin
                outer_next_state = OUTER_FALLING;
                prev_walk_direction = inner_state;
            end
        end
        OUTER_IDLE: begin
            // Do nothing
        end
    endcase
end

endmodule