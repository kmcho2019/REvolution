module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

    // State encoding: [direction(2), mode(1), digging(0)]
    // direction: 0=left, 1=right
    // mode: 0=walk, 1=fall
    // digging: 0=not digging, 1=digging

    reg [2:0] state;

    wire direction = state[2];
    wire mode      = state[1];
    wire digging_r = state[0];

    // Next mode logic
    // Fall if no ground (overrides others)
    // Resume walk if ground returns while falling
    // Otherwise mode remains walk (0)
    wire next_mode;
    assign next_mode = (!ground) ? 1'b1 :
                       (mode == 1'b1 && ground) ? 1'b0 :
                       mode;

    // Next digging logic
    // Digging only possible if walking on ground and dig input asserted
    // Digging continues until ground lost (fall), then stops
    // Digging is 0 during fall (next_mode==1)
    wire next_digging;
    assign next_digging = (next_mode == 1'b1) ? 1'b0 : // no digging if falling
                          (digging_r) ? // continue digging if already digging and on ground
                            (ground ? 1'b1 : 1'b0) :
                          (dig && ground && (mode==1'b0)) ? 1'b1 : // start digging if commanded and walking on ground
                          1'b0;

    // Next direction logic
    // Only change direction if walking on ground and not digging (i.e. mode=0 and digging=0)
    // Direction flips if bump left or bump right (or both) - flips direction or forced direction depending on bump side
    // When falling or digging, direction remains unchanged
    wire next_direction;
    wire bumped = bump_left || bump_right;

    // Direction change conditions when walking on ground and not digging
    wire walking_and_not_digging = (next_mode == 1'b0) && (next_digging == 1'b0);

    // Compute next direction:
    // If bumped (any bump), flip or set accordingly
    // Both bump: flip direction
    // bump_left only: direction to right (1)
    // bump_right only: direction to left (0)
    wire direction_flipped = ~direction;
    assign next_direction = (walking_and_not_digging && bumped) ?
                               ((bump_left && bump_right) ? direction_flipped :
                                (bump_left ? 1'b1 : 1'b0)) :
                               direction;

    // Combine next state signals
    wire [2:0] next_state = {next_direction, next_mode, next_digging};

    // Sequential state update with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 3'b000; // walk left, walk mode, no digging
        end else begin
            state <= next_state;
        end
    end

    // Moore outputs derived from state bits
    assign walk_left  = (mode == 1'b0) && (direction == 1'b0) && (digging_r == 1'b0);
    assign walk_right = (mode == 1'b0) && (direction == 1'b1) && (digging_r == 1'b0);
    assign aaah       = (mode == 1'b1);
    assign digging    = digging_r;

endmodule