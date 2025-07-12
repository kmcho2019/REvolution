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

    // State encoding:
    // bit1 (falling): 0 = walking, 1 = falling
    // bit0 (direction): 0 = left, 1 = right
    reg [1:0] state;

    // State encoding constants for clarity
    localparam WALK_LEFT  = 2'b00;
    localparam WALK_RIGHT = 2'b01;
    localparam FALL_LEFT  = 2'b10;
    localparam FALL_RIGHT = 2'b11;

    // Next state logic combinational
    wire falling     = state[1];
    wire direction   = state[0];

    reg [1:0] next_state;

    always @* begin
        if (falling) begin
            // Falling state: ignore bumps, wait for ground to return
            if (ground) begin
                // Ground returned: resume walking with same direction
                next_state = {1'b0, direction}; // walking with previous direction
            end else begin
                // Still falling
                next_state = state;
            end
        end else begin
            // Walking state
            if (!ground) begin
                // Start falling, keep same direction
                next_state = {1'b1, direction};
            end else begin
                // On ground and walking: update direction based on bumps
                if (bump_left && bump_right) begin
                    // Both bumps flip direction
                    next_state = {1'b0, ~direction};
                end else if (bump_left) begin
                    // bump_left switches to walking right
                    next_state = {1'b0, 1'b1};
                end else if (bump_right) begin
                    // bump_right switches to walking left
                    next_state = {1'b0, 1'b0};
                end else begin
                    // No bumps: remain walking same direction
                    next_state = state;
                end
            end
        end
    end

    // Sequential logic with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT; // reset to walking left
        end else begin
            state <= next_state;
        end
    end

    // Moore outputs
    assign aaah       = falling;
    assign walk_left  = (~falling) & (~direction);
    assign walk_right = (~falling) & direction;

endmodule