module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah
);
    // Registers for direction and falling status
    reg direction;   // 0 = left, 1 = right
    reg falling;     // 1 = falling, 0 = walking

    // For ground edge detection
    reg ground_d;    // delayed ground signal

    // Next state variables
    reg next_direction;
    reg next_falling;

    // Edge detection for ground signal
    wire ground_falling_edge = (ground_d == 1) && (ground == 0);
    wire ground_rising_edge  = (ground_d == 0) && (ground == 1);

    // Asynchronous reset and sequential logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            direction <= 1'b0;  // walk left on reset
            falling <= 1'b0;    // not falling on reset
            ground_d <= 1'b1;   // assume ground present initially
        end else begin
            direction <= next_direction;
            falling <= next_falling;
            ground_d <= ground;
        end
    end

    // Next state logic: Moore FSM
    always @(*) begin
        // Default next state is current state
        next_direction = direction;
        next_falling = falling;

        if (!falling) begin
            // Walking state
            if (ground_falling_edge) begin
                // Ground disappeared: start falling, hold direction
                next_falling = 1'b1;
            end else if ((bump_left || bump_right) && !ground_falling_edge && !ground_rising_edge) begin
                // Bump(s) detected and ground stable (no transition this cycle)
                next_direction = ~direction;  // flip direction
            end
            // Ignore bumps if ground changes this cycle
        end else begin
            // Falling state
            if (ground_rising_edge) begin
                // Ground reappeared: stop falling, keep direction
                next_falling = 1'b0;
            end
            // Ignore bumps while falling
        end
    end

    // Output logic (Moore machine)
    assign aaah = falling;
    assign walk_left = (!falling) && (direction == 1'b0);
    assign walk_right = (!falling) && (direction == 1'b1);

endmodule