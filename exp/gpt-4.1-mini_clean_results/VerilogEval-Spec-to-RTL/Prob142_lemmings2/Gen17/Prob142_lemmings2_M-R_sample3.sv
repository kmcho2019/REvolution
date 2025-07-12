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

    // State encoding: bit1 = falling, bit0 = direction (0=left,1=right)
    localparam WALK_LEFT  = 2'b00;
    localparam WALK_RIGHT = 2'b01;
    localparam FALL_LEFT  = 2'b10;
    localparam FALL_RIGHT = 2'b11;

    reg [1:0] state, next_state;

    // Combinational logic to determine next state
    always @(*) begin
        // Default next state is current state
        next_state = state;

        // Extract current falling and direction bits
        wire falling   = state[1];
        wire direction = state[0];

        if (falling) begin
            // When falling: ignore bumps, only respond to ground restoration
            if (ground) begin
                // Ground reappeared: go back to walking in previous direction
                next_state = {1'b0, direction};
            end
            // else remain falling
        end else begin
            // When walking on ground:
            if (!ground) begin
                // Start falling, preserve direction
                next_state = {1'b1, direction};
            end else begin
                // On ground and walking: bumps flip direction
                if (bump_left | bump_right) begin
                    // If bumped on either or both sides, flip direction
                    // Special case bump_left & bump_right together is same as either
                    next_state = {1'b0, ~direction};
                end
                // else no bump, stay walking same direction
            end
        end
    end

    // Sequential logic for state update with asynchronous reset (posedge)
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT; // Reset to walking left
        end else begin
            state <= next_state;
        end
    end

    // Moore outputs decoded from current state
    assign aaah       = state[1];
    assign walk_left  = (~state[1]) & (~state[0]);
    assign walk_right = (~state[1]) & (state[0]);

endmodule