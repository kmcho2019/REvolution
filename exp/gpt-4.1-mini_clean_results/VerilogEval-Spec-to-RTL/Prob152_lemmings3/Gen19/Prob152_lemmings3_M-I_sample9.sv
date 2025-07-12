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

    // State encoding: 2 bits: [direction, mode]
    // direction: 0=left, 1=right (bit 1)
    // mode: 0=walk, 1=fall (bit 0)
    localparam WALK_LEFT  = 2'b00; // direction=0, mode=0
    localparam WALK_RIGHT = 2'b10; // direction=1, mode=0
    localparam FALL_LEFT  = 2'b01; // direction=0, mode=1
    localparam FALL_RIGHT = 2'b11; // direction=1, mode=1

    reg [1:0] state, next_state;
    reg digging_r, digging_next;

    wire direction = state[1];
    wire mode      = state[0]; // 0=walk,1=fall

    // Next state logic
    always @(*) begin
        // Default next state
        next_state = state;
        digging_next = digging_r;

        // Priority 1: Falling (ground==0) overrides everything else
        if (!ground) begin
            // Enter falling mode, digging stops
            next_state = {direction, 1'b1}; // mode=fall
            digging_next = 1'b0;
        end else if (mode == 1'b1) begin
            // Was falling, ground came back, resume walking (no digging)
            next_state = {direction, 1'b0}; // mode=walk
            digging_next = 1'b0;
        end else begin
            // mode=walk and ground=1
            if (digging_r) begin
                // Currently digging, continue digging while ground=1
                // If ground lost, will fall next cycle (handled above)
                next_state = state;
                digging_next = 1'b1;
            end else begin
                // Not digging
                if (dig) begin
                    // Start digging
                    next_state = state; // stay walking same direction
                    digging_next = 1'b1;
                end else if (bump_left || bump_right) begin
                    // Change direction if bumped (while walking and not digging)
                    // Flip direction if both bumps or single bump
                    if (bump_left && bump_right) begin
                        next_state = {~direction, 1'b0}; // flip direction, walk mode
                    end else if (bump_left) begin
                        next_state = {1'b1, 1'b0}; // walk right
                    end else begin // bump_right
                        next_state = {1'b0, 1'b0}; // walk left
                    end
                    digging_next = 1'b0; // ensure digging off
                end else begin
                    // No bump, no dig, no fall
                    next_state = state;
                    digging_next = 1'b0;
                end
            end
        end
    end

    // Sequential logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            digging_r <= 1'b0;
        end else begin
            state <= next_state;
            digging_r <= digging_next;
        end
    end

    // Outputs (Moore)
    assign walk_left  = (mode == 1'b0) && (direction == 1'b0) && (digging_r == 1'b0);
    assign walk_right = (mode == 1'b0) && (direction == 1'b1) && (digging_r == 1'b0);
    assign aaah       = (mode == 1'b1);
    assign digging    = digging_r;

endmodule