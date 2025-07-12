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
    // bit1: falling (1) / walking (0)
    // bit0: direction: 0=left, 1=right
    reg [1:0] state;
    wire walking = ~state[1];
    wire falling = state[1];
    wire direction = state[0];

    // Determine if bump causes direction flip (only when walking)
    wire bumped = bump_left | bump_right;

    // Calculate next falling bit
    wire next_falling;
    assign next_falling = (walking && ~ground) ? 1'b1 :    // start falling
                         (falling && ~ground) ? 1'b1 :     // keep falling
                         (falling && ground) ? 1'b0 :      // ground reappeared, stop falling
                         state[1];                         // otherwise hold

    // Calculate next direction bit
    wire next_direction;
    assign next_direction = (walking && ground && bumped) ? ~direction : // flip direction if bumped on ground
                           direction;                                // else keep same

    wire next_grounded = ~next_falling; // just for clarity, not used directly

    wire next_direction_respected;
    // Actually, if falling, direction does not change. If walking on ground and bumped, direction flips.
    // We encoded that in next_direction above

    wire [1:0] next_state = {next_falling, next_direction};

    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 2'b00; // walk_left on reset
        else
            state <= next_state;
    end

    // Outputs decode
    assign aaah       = state[1];
    assign walk_left  = walking && ~direction;
    assign walk_right = walking && direction;

endmodule