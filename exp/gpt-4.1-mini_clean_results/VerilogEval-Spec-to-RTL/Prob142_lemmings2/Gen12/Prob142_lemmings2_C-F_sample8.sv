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

    // State encoding using named localparams for clarity
    localparam WALK_LEFT  = 2'b00; // falling=0, direction=0
    localparam WALK_RIGHT = 2'b01; // falling=0, direction=1
    localparam FALL_LEFT  = 2'b10; // falling=1, direction=0
    localparam FALL_RIGHT = 2'b11; // falling=1, direction=1

    reg [1:0] state, next_state;

    // Extract bits for convenience
    wire falling   = state[1];
    wire direction = state[0];

    // Combinational next-state logic
    always @(*) begin
        next_state = state; // Default: hold state

        if (falling) begin
            // Currently falling: ignore bumps
            if (ground) begin
                // Ground reappeared: resume walking in same direction
                next_state = {1'b0, direction};
            end
            // else remain falling, same direction
        end else begin
            // Currently walking and on ground or possibly starting to fall
            if (!ground) begin
                // Ground lost: start falling, preserve direction
                next_state = {1'b1, direction};
            end else begin
                // On ground, walking: bumps cause direction flips
                if (bump_left && bump_right) begin
                    // Both bumps: flip direction
                    next_state = {1'b0, ~direction};
                end else if (bump_left) begin
                    // Bump left: walk right
                    next_state = {1'b0, 1'b1};
                end else if (bump_right) begin
                    // Bump right: walk left
                    next_state = {1'b0, 1'b0};
                end
                // else no bump, hold direction
            end
        end
    end

    // Sequential logic with asynchronous reset (active high)
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT; // Reset to walking left
        end else begin
            state <= next_state;
        end
    end

    // Moore outputs directly from state bits
    assign aaah       = falling;
    assign walk_left  = ~falling & ~direction;
    assign walk_right = ~falling & direction;

endmodule