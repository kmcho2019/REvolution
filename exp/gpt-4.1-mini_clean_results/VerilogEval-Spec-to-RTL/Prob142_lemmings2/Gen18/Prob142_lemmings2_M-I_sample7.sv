module TopModule(
    input  wire clk,
    input  wire areset,
    input  wire bump_left,
    input  wire bump_right,
    input  wire ground,
    output reg  walk_left,
    output reg  walk_right,
    output reg  aaah
);

    // State encoding with named constants for clarity
    localparam WALK_LEFT  = 2'b00; // falling=0, direction=0
    localparam WALK_RIGHT = 2'b01; // falling=0, direction=1
    localparam FALL_LEFT  = 2'b10; // falling=1, direction=0
    localparam FALL_RIGHT = 2'b11; // falling=1, direction=1

    reg [1:0] state, next_state;

    wire falling   = state[1];
    wire direction = state[0];

    // Combine bumps condition: any bump triggers direction change (if walking)
    wire bump_any = bump_left | bump_right;

    // Next state logic
    always @(*) begin
        next_state = state; // default: hold state

        if (falling) begin
            // Falling: ignore bumps, only transition to walking when ground returns
            if (ground)
                next_state = {1'b0, direction};
        end else begin
            // Walking
            if (!ground) begin
                // Start falling, preserve direction
                next_state = {1'b1, direction};
            end else if (bump_any) begin
                // Bumped while walking: flip direction
                next_state = {1'b0, ~direction};
            end
            // else hold walking direction
        end
    end

    // Sequential state update with async reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= WALK_LEFT;
        else if (state != next_state)
            state <= next_state;
    end

    // Registered outputs to reduce glitches and toggling
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            walk_left  <= 1'b1;
            walk_right <= 1'b0;
            aaah       <= 1'b0;
        end else begin
            aaah       <= falling;
            walk_left  <= (~falling) & (~direction);
            walk_right <= (~falling) & direction;
        end
    end

endmodule