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

    // State encoding: bit1 = falling, bit0 = direction
    localparam WALK_LEFT  = 2'b00; // falling=0, direction=0
    localparam WALK_RIGHT = 2'b01; // falling=0, direction=1
    localparam FALL_LEFT  = 2'b10; // falling=1, direction=0
    localparam FALL_RIGHT = 2'b11; // falling=1, direction=1

    reg [1:0] state, next_state;

    wire falling   = state[1];
    wire direction = state[0];
    wire bump      = bump_left | bump_right;

    always @* begin
        // Default to current state to avoid inferred latches
        next_state = state;

        if (falling) begin
            // While falling, ignore bumps; check if ground returns
            if (ground)
                next_state = {1'b0, direction}; // land, resume walking same direction
            else
                next_state = state;              // stay falling
        end else begin
            // Walking state
            if (!ground) begin
                // Ground disappeared: start falling same direction
                next_state = {1'b1, direction};
            end else if (bump) begin
                // On ground and bumped: update direction per bump rules
                if (bump_left && bump_right)
                    next_state = {1'b0, ~direction};  // both bumps flip direction
                else if (bump_left)
                    next_state = {1'b0, 1'b1};         // bump left -> walk right
                else // bump_right only
                    next_state = {1'b0, 1'b0};         // bump right -> walk left
            end else begin
                // No change: keep walking same direction
                next_state = state;
            end
        end
    end

    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= WALK_LEFT; // async reset to walking left
        else
            state <= next_state;
    end

    // Moore outputs from current state
    assign aaah       = falling;
    assign walk_left  = ~falling & ~direction;
    assign walk_right = ~falling &  direction;

endmodule