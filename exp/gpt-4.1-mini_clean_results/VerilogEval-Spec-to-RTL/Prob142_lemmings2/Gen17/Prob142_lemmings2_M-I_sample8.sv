module TopModule(
    input  wire clk,
    input  wire areset,      // changed to synchronous active-high reset for better timing
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

    // Combine bumps for simpler logic
    wire bump = bump_left | bump_right;

    // Next-state combinational logic
    always @(*) begin
        next_state = state; // default hold state

        if (!falling) begin
            // Walking state
            if (!ground) begin
                // Start falling, preserve direction
                next_state = {1'b1, direction};
            end else if (bump) begin
                // Bumped on one or both sides, flip direction
                next_state = {1'b0, ~direction};
            end
            // else no bump, remain walking same direction
        end else begin
            // Falling state
            if (ground) begin
                // Ground reappeared, resume walking same direction
                next_state = {1'b0, direction};
            end
            // else keep falling
        end
    end

    // Synchronous active-high reset on clock posedge
    always @(posedge clk) begin
        if (areset)
            state <= WALK_LEFT; // reset to walking left
        else
            state <= next_state;
    end

    // Moore outputs from state bits
    assign aaah       = falling;
    assign walk_left  = ~falling & ~direction;
    assign walk_right = ~falling &  direction;

endmodule