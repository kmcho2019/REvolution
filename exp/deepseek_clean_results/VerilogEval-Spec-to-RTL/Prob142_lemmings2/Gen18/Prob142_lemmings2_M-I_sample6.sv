module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah
);

    // One-hot encoding: [1:0] - [FALL, WALK]
    // direction is stored in bit 2
    reg [2:0] state_dir;  // {direction, FALL, WALK}

    wire walking = state_dir[0];
    wire falling = state_dir[1];
    wire dir = state_dir[2];

    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state_dir <= 3'b001;  // WALK, left
        end else begin
            if (falling) begin
                if (ground) state_dir <= {dir, 2'b01};  // Return to walking
            end else if (walking) begin
                if (!ground) begin
                    state_dir <= {dir, 2'b10};  // Start falling
                end else if ((bump_left && !dir) || (bump_right && dir)) begin
                    state_dir <= {~dir, 2'b01};  // Switch direction
                end
            end
        end
    end

    assign walk_left = walking & ~dir;
    assign walk_right = walking & dir;
    assign aaah = falling;

endmodule