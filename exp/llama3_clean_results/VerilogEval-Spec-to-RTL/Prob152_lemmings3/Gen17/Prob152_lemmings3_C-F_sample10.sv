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
enum logic [1:0] {
    WALKING,
    FALLING,
    DIGGING
} state, next_state;

// Define the walking direction
reg walk_direction;
reg next_walk_direction;

// Sequential logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALKING;
        walk_direction <= 0; // left
    end else begin
        state <= next_state;
        walk_direction <= next_walk_direction;
    end
end

// Combinational logic
always_comb begin
    next_state = state;
    next_walk_direction = walk_direction;
    
    case (state)
        WALKING: begin
            if (!ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING;
            end else if (bump_left) begin
                next_walk_direction = 1; // right
            end else if (bump_right) begin
                next_walk_direction = 0; // left
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

// Output logic
always_comb begin
    walk_left = (state == WALKING &&!walk_direction)? 1'b1 : 1'b0;
    walk_right = (state == WALKING && walk_direction)? 1'b1 : 1'b0;
    aaah = (state == FALLING)? 1'b1 : 1'b0;
    digging = (state == DIGGING)? 1'b1 : 1'b0;
end

endmodule