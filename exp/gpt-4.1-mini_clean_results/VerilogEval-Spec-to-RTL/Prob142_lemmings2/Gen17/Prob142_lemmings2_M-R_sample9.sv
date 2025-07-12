module TopModule(
    input  wire clk,
    input  wire areset,
    input  wire bump_left,
    input  wire bump_right,
    input  wire ground,
    output wire walk_left,
    output wire walk_right,
    output wire aaah
);

    // Separate state bits for clarity:
    // direction: 0 = left, 1 = right
    // falling: 1 = falling, 0 = walking
    reg direction;
    reg falling;

    reg direction_next;
    reg falling_next;

    // Next-state combinational logic
    always @(*) begin
        // Default to hold current state
        direction_next = direction;
        falling_next = falling;

        if (falling == 1'b0) begin
            // Walking state
            if (ground == 1'b0) begin
                // Start falling, keep direction
                falling_next = 1'b1;
                direction_next = direction;
            end else if (bump_left & bump_right) begin
                // Both bumps flip direction
                direction_next = ~direction;
            end else if (bump_left) begin
                // Bumped left: walk right
                direction_next = 1'b1;
            end else if (bump_right) begin
                // Bumped right: walk left
                direction_next = 1'b0;
            end
            // else no change
        end else begin
            // Falling state
            if (ground == 1'b1) begin
                // Landed, resume walking in same direction
                falling_next = 1'b0;
                // direction unchanged
            end
            // else continue falling, no change to direction
        end
    end

    // Sequential logic with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Reset: walk left, not falling
            direction <= 1'b0;
            falling <= 1'b0;
        end else begin
            direction <= direction_next;
            falling <= falling_next;
        end
    end

    // Moore outputs from state bits
    assign aaah       = falling;
    assign walk_left  = (~falling) & (~direction);
    assign walk_right = (~falling) & direction;

endmodule