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

    always @* begin
        if (falling) begin
            // Falling: remain falling until ground returns, ignoring bumps
            if (ground)
                next_state = {1'b0, direction}; // resume walking same direction
            else
                next_state = state;              // keep falling
        end else begin
            // Walking state
            if (!ground) begin
                // Ground disappeared: start falling same direction
                next_state = {1'b1, direction};
            end else begin
                // Walking on ground, bumps update direction
                if (bump_left && bump_right) begin
                    // Both bumps: flip direction
                    next_state = {1'b0, ~direction};
                end else if (bump_left) begin
                    // Bump left: walk right
                    next_state = {1'b0, 1'b1};
                end else if (bump_right) begin
                    // Bump right: walk left
                    next_state = {1'b0, 1'b0};
                end else begin
                    // No bumps: maintain direction
                    next_state = state;
                end
            end
        end
    end

    // Sequential logic with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= WALK_LEFT; // reset to walking left
        else
            state <= next_state;
    end

    // Moore outputs
    assign aaah       = falling;
    assign walk_left  = ~falling & ~direction;
    assign walk_right = ~falling &  direction;

endmodule