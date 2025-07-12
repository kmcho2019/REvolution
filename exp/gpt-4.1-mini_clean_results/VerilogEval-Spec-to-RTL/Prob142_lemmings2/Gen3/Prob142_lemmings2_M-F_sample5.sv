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

    // Synchronize asynchronous ground input to clk domain (2-stage synchronizer)
    reg ground_sync1, ground_sync2;
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ground_sync1 <= 1'b1; // assume ground present on reset
            ground_sync2 <= 1'b1;
        end else begin
            ground_sync1 <= ground;
            ground_sync2 <= ground_sync1;
        end
    end

    // Edge detection on synchronized ground signals
    reg ground_sync2_d;
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            ground_sync2_d <= 1'b1;
        end else begin
            ground_sync2_d <= ground_sync2;
        end
    end

    wire ground_falling_edge = (ground_sync2_d == 1'b1) && (ground_sync2 == 1'b0);
    wire ground_rising_edge  = (ground_sync2_d == 1'b0) && (ground_sync2 == 1'b1);

    // FSM state registers
    reg direction; // 0=left,1=right
    reg falling;   // 0=walking,1=falling

    // Next state signals
    reg next_direction;
    reg next_falling;

    // FSM sequential logic with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            direction <= 1'b0; // walk left on reset
            falling <= 1'b0;   // not falling on reset
        end else begin
            direction <= next_direction;
            falling <= next_falling;
        end
    end

    // Next state combinational logic
    always @(*) begin
        // default hold current state
        next_direction = direction;
        next_falling = falling;

        if (!falling) begin
            // Walking state
            if (ground_falling_edge) begin
                // Ground disappeared, start falling, keep direction
                next_falling = 1'b1;
            end else if ((bump_left || bump_right) && !ground_falling_edge && !ground_rising_edge) begin
                // Bump detected and ground stable this cycle: flip direction
                next_direction = ~direction;
            end
            // else no change
        end else begin
            // Falling state
            if (ground_rising_edge) begin
                // Ground reappeared, stop falling, keep direction
                next_falling = 1'b0;
            end
            // bumps ignored while falling
        end
    end

    // Output logic (Moore FSM)
    assign aaah = falling;
    assign walk_left = (!falling) && (direction == 1'b0);
    assign walk_right = (!falling) && (direction == 1'b1);

endmodule