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
    // bit1: falling (1) or walking (0)
    // bit0: direction (0 = left, 1 = right)
    localparam WALK_LEFT  = 2'b00;
    localparam WALK_RIGHT = 2'b01;
    localparam FALL_LEFT  = 2'b10;
    localparam FALL_RIGHT = 2'b11;

    reg [1:0] state, next_state;

    wire falling   = state[1];
    wire direction = state[0];
    wire bumped = bump_left | bump_right;

    always @(*) begin
        // Default hold state
        next_state = state;

        if (!falling) begin
            // Walking and grounded state behavior
            if (!ground) begin
                // Start falling, keep direction
                next_state = {1'b1, direction};
            end else if (bumped) begin
                // On bump (left, right, or both) while walking and grounded, flip direction
                next_state = {1'b0, ~direction};
            end
            // else no bump, remain walking same direction
        end else begin
            // Falling state
            if (ground) begin
                // Ground regained, resume walking with same direction
                next_state = {1'b0, direction};
            end
            // else continue falling, ignore bumps
        end
    end

    // Sequential logic with asynchronous reset (areset active high)
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= WALK_LEFT; // Reset to walking left
        else
            state <= next_state;
    end

    // Moore outputs
    assign aaah       = falling;
    assign walk_left  = ~falling & ~direction;
    assign walk_right = ~falling &  direction;

endmodule