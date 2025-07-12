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

// Define states as enum
enum logic [1:0] {FALLING, WALKING, DIGGING} state, next_state;
reg walk_direction, next_walk_direction;

// Use always_ff for sequential logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALKING;
        walk_direction <= 0;
    end else begin
        state <= next_state;
        walk_direction <= next_walk_direction;
    end
end

// Use always_comb for combinational logic
always_comb begin
    next_state = state;
    next_walk_direction = walk_direction;

    // Simplify state transitions
    case (state)
        FALLING: begin
            if (ground) begin
                next_state = WALKING;
            end
        end
        WALKING: begin
            if (!ground) begin
                next_state = FALLING;
            end else if (dig) begin
                next_state = DIGGING;
            end else if (bump_left || bump_right) begin
                next_walk_direction = ~walk_direction;
            end
        end
        DIGGING: begin
            if (!ground) begin
                next_state = FALLING;
            end
        end
    endcase
end

// Use assign statements for output logic
assign walk_left = (state == WALKING && ~walk_direction);
assign walk_right = (state == WALKING && walk_direction);
assign aaah = (state == FALLING);
assign digging = (state == DIGGING);

endmodule