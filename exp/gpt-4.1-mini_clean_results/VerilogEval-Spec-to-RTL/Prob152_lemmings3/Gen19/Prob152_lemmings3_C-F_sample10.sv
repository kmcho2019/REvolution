module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

    // State encoding (3 bits):
    // bit 2: direction (0=left, 1=right)
    // bit 1-0: mode (00=walk, 01=fall, 10=dig)
    localparam MODE_WALK = 2'b00,
               MODE_FALL = 2'b01,
               MODE_DIG  = 2'b10;

    reg [2:0] state, next_state;

    wire direction = state[2];
    wire [1:0] mode = state[1:0];

    always @(*) begin
        // Default next state holds current state
        next_state = state;

        if (!ground) begin
            // 1) Fall has highest priority; cancel dig and fall
            next_state = {direction, MODE_FALL};
        end else if (mode == MODE_FALL) begin
            // 2) From fall to walk when ground returns
            next_state = {direction, MODE_WALK};
        end else if (mode == MODE_WALK) begin
            // 3) Walk to dig if dig=1
            if (dig) begin
                next_state = {direction, MODE_DIG};
            end else if (bump_left || bump_right) begin
                // 4) Bump changes direction while walking
                if (bump_left && bump_right)
                    next_state = {~direction, MODE_WALK};
                else if (bump_left)
                    next_state = {1'b1, MODE_WALK};  // walk right
                else // bump_right only
                    next_state = {1'b0, MODE_WALK};  // walk left
            end
            // else remain walking same direction
        end else if (mode == MODE_DIG) begin
            // 5) Digging continues if ground; else fall
            if (!ground)
                next_state = {direction, MODE_FALL};
            // else remain digging same direction
        end
    end

    // Sequential state update with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= {1'b0, MODE_WALK}; // walk left
        else
            state <= next_state;
    end

    // Outputs: only one of walk_left, walk_right, aaah, digging asserted at a time
    assign walk_left  = (mode == MODE_WALK) && (direction == 1'b0);
    assign walk_right = (mode == MODE_WALK) && (direction == 1'b1);
    assign aaah       = (mode == MODE_FALL);
    assign digging    = (mode == MODE_DIG);

endmodule