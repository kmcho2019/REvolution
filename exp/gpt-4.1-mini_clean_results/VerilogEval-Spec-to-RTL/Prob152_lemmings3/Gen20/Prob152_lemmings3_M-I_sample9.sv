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

    // Separate registers for direction and mode
    // direction: 0=left,1=right
    // mode: 0=walk,1=fall
    reg direction;
    reg mode;     // walk=0, fall=1
    reg digging_r;

    // Next state variables
    reg direction_next;
    reg mode_next;
    reg digging_next;

    // Bump detected if bump_left or bump_right asserted
    wire bumped = bump_left | bump_right;

    always @(*) begin
        // Default next state is current state
        direction_next = direction;
        mode_next = mode;
        digging_next = digging_r;

        if (!ground) begin
            // Priority 1: fall when no ground, stop digging
            mode_next = 1'b1; // fall
            digging_next = 1'b0;
            // direction stays same
        end else if (mode == 1'b1) begin
            // Ground returned from falling -> walk, no digging
            mode_next = 1'b0; // walk
            digging_next = 1'b0;
            // direction unchanged
        end else begin
            // mode=walk and ground=1
            if (digging_r) begin
                // Continue digging if already digging
                digging_next = 1'b1;
                // direction and mode unchanged
            end else if (dig) begin
                // Start digging if dig input asserted
                digging_next = 1'b1;
                // direction and mode unchanged
            end else if (bumped) begin
                // Flip direction if bumped when walking and not digging
                direction_next = ~direction;
                digging_next = 1'b0;
                // mode unchanged
            end else begin
                // No state change
                digging_next = 1'b0;
            end
        end
    end

    // Sequential logic with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            direction <= 1'b0; // walk left
            mode <= 1'b0;      // walk
            digging_r <= 1'b0;
        end else begin
            direction <= direction_next;
            mode <= mode_next;
            digging_r <= digging_next;
        end
    end

    // Moore outputs directly from state
    assign walk_left  = (mode == 1'b0) && (direction == 1'b0) && (digging_r == 1'b0);
    assign walk_right = (mode == 1'b0) && (direction == 1'b1) && (digging_r == 1'b0);
    assign aaah       = (mode == 1'b1);
    assign digging    = digging_r;

endmodule