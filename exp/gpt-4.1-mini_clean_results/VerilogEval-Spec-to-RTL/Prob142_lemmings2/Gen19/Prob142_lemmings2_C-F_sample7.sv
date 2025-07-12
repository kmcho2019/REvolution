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

    // State encoding with named localparams for clarity
    // bit1 = falling flag: 0 = walking, 1 = falling
    // bit0 = direction: 0 = left, 1 = right
    localparam WALK_LEFT  = 2'b00;
    localparam WALK_RIGHT = 2'b01;
    localparam FALL_LEFT  = 2'b10;
    localparam FALL_RIGHT = 2'b11;

    reg [1:0] state, next_state;

    // Separate state bits for readability
    wire falling   = state[1];
    wire direction = state[0];

    // Combinational next state logic using case statement with default
    always @(*) begin
        next_state = state; // default to hold current state

        case (state)
            WALK_LEFT: begin // walking left
                if (!ground) begin
                    // ground disappeared: start falling, preserve direction
                    next_state = FALL_LEFT;
                end else if (bump_left && bump_right) begin
                    // bump both sides: flip direction to right
                    next_state = WALK_RIGHT;
                end else if (bump_left) begin
                    // bumped left: turn right
                    next_state = WALK_RIGHT;
                end else if (bump_right) begin
                    // bumped right: stay walking left (no direction change)
                    next_state = WALK_LEFT;
                end
                // else no bump: remain walking left
            end

            WALK_RIGHT: begin // walking right
                if (!ground) begin
                    // ground disappeared: start falling, preserve direction
                    next_state = FALL_RIGHT;
                end else if (bump_left && bump_right) begin
                    // bump both sides: flip direction to left
                    next_state = WALK_LEFT;
                end else if (bump_left) begin
                    // bumped left: stay walking right (no direction change)
                    next_state = WALK_RIGHT;
                end else if (bump_right) begin
                    // bumped right: turn left
                    next_state = WALK_LEFT;
                end
                // else no bump: remain walking right
            end

            FALL_LEFT: begin // falling left
                if (ground) begin
                    // landed, resume walking left
                    next_state = WALK_LEFT;
                end
                // bumps ignored while falling
            end

            FALL_RIGHT: begin // falling right
                if (ground) begin
                    // landed, resume walking right
                    next_state = WALK_RIGHT;
                end
                // bumps ignored while falling
            end

            default: begin
                // safe default to walk left
                next_state = WALK_LEFT;
            end
        endcase
    end

    // Sequential logic with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
        end else begin
            state <= next_state;
        end
    end

    // Moore outputs decoded directly from state bits
    assign aaah       = falling;
    assign walk_left  = ~falling & ~direction;
    assign walk_right = ~falling &  direction;

endmodule