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

    // State encoding:
    // bit 1: direction (0=left,1=right)
    // bit 0: mode (0=walk,1=fall)
    localparam WLK_LEFT  = 2'b00;
    localparam WLK_RIGHT = 2'b10;
    localparam FAL_LEFT  = 2'b01;
    localparam FAL_RIGHT = 2'b11;

    reg [1:0] state, next_state;
    reg digging_r, digging_next;

    wire direction = state[1];
    wire mode      = state[0]; // 0=walk,1=fall

    always @(*) begin
        // Defaults: hold current state and digging flag
        next_state = state;
        digging_next = digging_r;

        // Priority 1: Falling when no ground, cancels digging
        if (!ground) begin
            next_state = {direction, 1'b1}; // fall in current direction
            digging_next = 1'b0;
        end else if (mode == 1'b1) begin
            // Priority 2: Ground returned while falling: walk same direction, stop digging
            next_state = {direction, 1'b0};
            digging_next = 1'b0;
        end else if (digging_r) begin
            // Priority 3: Continue digging if on ground and digging
            // Since ground=1 here, continue digging until ground lost (handled above)
            next_state = state;
            digging_next = 1'b1;
        end else begin
            // Priority 4: Walking, not digging, on ground
            if (dig) begin
                // Start digging
                digging_next = 1'b1;
                next_state = state;
            end else if (bump_left || bump_right) begin
                // Switch direction if bumped and walking/not digging
                if (bump_left && bump_right) begin
                    // Both bumps, flip direction
                    next_state = {~direction, 1'b0};
                end else if (bump_left) begin
                    next_state = {1'b1, 1'b0}; // walk right
                end else begin // bump_right
                    next_state = {1'b0, 1'b0}; // walk left
                end
                digging_next = 1'b0; // ensure digging off when direction switched
            end else begin
                // No change: keep walking same direction and digging off
                next_state = state;
                digging_next = 1'b0;
            end
        end
    end

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WLK_LEFT;   // walk left
            digging_r <= 1'b0;
        end else begin
            state <= next_state;
            digging_r <= digging_next;
        end
    end

    // Moore outputs
    assign walk_left  = (mode == 1'b0) && (direction == 1'b0) && (digging_r == 1'b0);
    assign walk_right = (mode == 1'b0) && (direction == 1'b1) && (digging_r == 1'b0);
    assign aaah       = (mode == 1'b1);
    assign digging    = digging_r;

endmodule