module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
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
    end else if (ground) begin
        if (state == WALKING) begin
            if (bump_left) begin
                walk_direction <= 1; // right
            end else if (bump_right) begin
                walk_direction <= 0; // left
            end
            if (dig) begin
                state <= DIGGING;
            end
        end else if (state == DIGGING) begin
            if (!ground) begin
                state <= FALLING;
            end
        end
    end else if (!ground) begin
        if (state == WALKING) begin
            state <= FALLING;
        end
    end
end

// Output logic
assign walk_left = (state == WALKING && !walk_direction) ? 1'b1 : 1'b0;
assign walk_right = (state == WALKING && walk_direction) ? 1'b1 : 1'b0;
assign aaah = (state == FALLING) ? 1'b1 : 1'b0;
assign digging = (state == DIGGING) ? 1'b1 : 1'b0;

endmodule