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
    // State encoding: 3 bits: {direction, mode[1:0]}
    // direction: bit 2: 0=left, 1=right
    // mode: bits [1:0]
    //   2'b00 = walking (not digging)
    //   2'b01 = digging
    //   2'b10 = falling
    //   2'b11 = unused (safe default)
    
    localparam MODE_WALK    = 2'b00;
    localparam MODE_DIG     = 2'b01;
    localparam MODE_FALL    = 2'b10;

    reg [2:0] state, next_state;
    wire direction = state[2];
    wire [1:0] mode = state[1:0];

    // Next state logic
    always @(*) begin
        next_state = state; // default hold
        // Priority: falling > digging > bump

        if (!ground) begin
            // Falling overrides all
            next_state = {direction, MODE_FALL};
        end else if (mode == MODE_FALL) begin
            // Was falling, ground returned: resume walking (no dig)
            next_state = {direction, MODE_WALK};
        end else if (mode == MODE_DIG) begin
            // Currently digging, continue digging if ground is still there
            // if ground lost, already handled above (fall)
            next_state = state; // stay digging same direction
        end else begin
            // Walking and ground present, not digging
            if (dig) begin
                // Start digging
                next_state = {direction, MODE_DIG};
            end else if (bump_left || bump_right) begin
                // Switch directions when bumped (either bump or both)
                // New direction logic:
                // bumped left -> walk right (direction=1)
                // bumped right -> walk left (direction=0)
                // bumped both -> direction flips
                if (bump_left && bump_right) begin
                    next_state = {~direction, MODE_WALK};
                end else if (bump_left) begin
                    next_state = {1'b1, MODE_WALK}; // walk right
                end else begin // bump_right
                    next_state = {1'b0, MODE_WALK}; // walk left
                end
            end else begin
                // Continue walking same direction
                next_state = state;
            end
        end
    end

    // Sequential logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= {1'b0, MODE_WALK}; // walk left and walking mode
        end else begin
            state <= next_state;
        end
    end

    // Output logic (Moore)
    assign walk_left  = (mode == MODE_WALK) && (direction == 1'b0);
    assign walk_right = (mode == MODE_WALK) && (direction == 1'b1);
    assign digging    = (mode == MODE_DIG);
    assign aaah       = (mode == MODE_FALL);

endmodule