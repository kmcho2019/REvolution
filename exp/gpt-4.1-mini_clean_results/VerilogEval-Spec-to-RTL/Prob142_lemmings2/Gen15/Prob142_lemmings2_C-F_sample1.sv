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
    // bit1 = falling (1) or walking (0)
    // bit0 = direction: 0 = left, 1 = right
    localparam WALK_LEFT  = 2'b00;
    localparam WALK_RIGHT = 2'b01;
    localparam FALL_LEFT  = 2'b10;
    localparam FALL_RIGHT = 2'b11;

    reg [1:0] state, next_state;

    wire falling   = state[1];
    wire direction = state[0];

    // Combinational next-state logic with default to hold current state
    always @(*) begin
        next_state = state;

        if (!falling) begin
            // Walking state
            if (!ground) begin
                // Ground disappeared: start falling, preserve direction
                next_state = {1'b1, direction};
            end else begin
                // Grounded and walking: bumps may change direction
                if (bump_left && bump_right) begin
                    // Bumps both sides: flip direction
                    next_state = {1'b0, ~direction};
                end else if (bump_left) begin
                    // Bump left: walk right
                    next_state = WALK_RIGHT;
                end else if (bump_right) begin
                    // Bump right: walk left
                    next_state = WALK_LEFT;
                end
                // else no bumps: hold current walking direction
            end
        end else begin
            // Falling state
            if (ground) begin
                // Ground reappeared: resume walking with same direction
                next_state = {1'b0, direction};
            end
            // else remain falling, ignore bumps
        end
    end

    // Sequential logic with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= WALK_LEFT; // Reset to walking left
        else
            state <= next_state;
    end

    // Moore outputs from state bits
    assign aaah       = falling;
    assign walk_left  = ~falling & ~direction;
    assign walk_right = ~falling &  direction;

endmodule