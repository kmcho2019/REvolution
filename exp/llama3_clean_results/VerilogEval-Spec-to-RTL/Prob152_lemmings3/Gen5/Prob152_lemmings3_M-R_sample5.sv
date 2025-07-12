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
    FALLING = 2'b00,
    WALKING = 2'b01,
    DIGGING = 2'b10
} state, next_state;

// Define the walking directions
reg walk_direction;

// Sequential logic
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= WALKING;
        walk_direction <= 1'b0;
    end else begin
        state <= next_state;
        if (state == WALKING && (bump_left || bump_right)) begin
            walk_direction <= ~walk_direction;
        end
    end
end

// Combinational logic for next state
always_comb begin
    next_state = state;
    if (state == WALKING) begin
        if (!ground) begin
            next_state = FALLING;
        end else if (dig) begin
            next_state = DIGGING;
        end
    end else if (state == FALLING) begin
        if (ground) begin
            next_state = WALKING;
        end
    end else if (state == DIGGING) begin
        if (!ground) begin
            next_state = FALLING;
        end
    end
end

// Output logic using assign statements
assign walk_left = (state == WALKING && !walk_direction);
assign walk_right = (state == WALKING && walk_direction);
assign aaah = (state == FALLING);
assign digging = (state == DIGGING);

endmodule