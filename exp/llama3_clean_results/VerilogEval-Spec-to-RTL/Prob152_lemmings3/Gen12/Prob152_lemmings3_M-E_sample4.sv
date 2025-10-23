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

// Walking sub-state machine
reg walking;
reg walk_direction;

// Falling and digging sub-state machine
reg falling;
reg digging_state;

// Top-level state machine
always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        walking <= 1;
        falling <= 0;
        digging_state <= 0;
        walk_direction <= 0; // left
    end else begin
        // Top-level state machine
        if (ground) begin
            if (digging_state) begin
                // Digging
                if (!ground) begin
                    digging_state <= 0;
                    falling <= 1;
                end
            end else if (walking) begin
                // Walking
                if (dig) begin
                    digging_state <= 1;
                end else if (!ground) begin
                    walking <= 0;
                    falling <= 1;
                end else if (bump_left) begin
                    walk_direction <= 1; // right
                end else if (bump_right) begin
                    walk_direction <= 0; // left
                end
            end
        end else begin
            // Falling
            if (ground) begin
                falling <= 0;
                walking <= 1;
            end
        end
    end
end

// Output logic
always_comb begin
    walk_left = walking && !walk_direction ? 1'b1 : 1'b0;
    walk_right = walking && walk_direction ? 1'b1 : 1'b0;
    aaah = falling ? 1'b1 : 1'b0;
    digging = digging_state ? 1'b1 : 1'b0;
end

endmodule