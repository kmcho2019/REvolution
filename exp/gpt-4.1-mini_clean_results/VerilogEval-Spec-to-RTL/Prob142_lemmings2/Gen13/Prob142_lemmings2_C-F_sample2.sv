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

    // State encoding (2 bits):
    // bit1 = falling (1) or walking (0)
    // bit0 = direction (0 = left, 1 = right)
    localparam WALK_LEFT  = 2'b00;
    localparam WALK_RIGHT = 2'b01;
    localparam FALL_LEFT  = 2'b10;
    localparam FALL_RIGHT = 2'b11;

    reg [1:0] state, next_state;

    // Extract state bits for clarity
    wire falling   = state[1];
    wire direction = state[0];

    // Combinational next-state logic
    always @(*) begin
        next_state = state; // Default hold

        if (falling) begin
            // Falling: ignore bumps; resume walking same direction when ground returns
            if (ground) begin
                next_state = {1'b0, direction};
            end
        end else begin
            // Walking on ground or about to fall
            if (!ground) begin
                // Ground gone: start falling, preserve direction
                next_state = {1'b1, direction};
            end else begin
                // On ground and walking: respond to bumps
                if (bump_left && bump_right) begin
                    // Both bumps: flip direction
                    next_state = {1'b0, ~direction};
                end else if (bump_left) begin
                    // Bump left: walk right
                    next_state = WALK_RIGHT;
                end else if (bump_right) begin
                    // Bump right: walk left
                    next_state = WALK_LEFT;
                end
                // else no bump: remain in current walking direction
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

    // Moore outputs derived directly from state bits
    assign aaah       = falling;
    assign walk_left  = (~falling) & (~direction);
    assign walk_right = (~falling) & direction;

endmodule