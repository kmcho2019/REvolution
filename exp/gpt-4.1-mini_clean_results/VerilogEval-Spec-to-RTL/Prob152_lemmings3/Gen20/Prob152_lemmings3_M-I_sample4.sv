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

    // FSM states for direction and mode (fall/walk)
    // 2 bits:
    // bit1 = direction: 0=left, 1=right
    // bit0 = mode: 0=walk, 1=fall
    localparam WALK_LEFT  = 2'b00;
    localparam FALL_LEFT  = 2'b01;
    localparam WALK_RIGHT = 2'b10;
    localparam FALL_RIGHT = 2'b11;

    reg [1:0] state, next_state;
    reg digging_r, digging_next;

    wire direction = state[1];
    wire mode = state[0]; // 0=walk, 1=fall

    // Next state logic and digging flag update
    always @(*) begin
        // Default assignments
        next_state = state;
        digging_next = digging_r;

        // Priority:
        // 1) Falling if no ground
        // 2) Resume walking when ground returns if falling
        // 3) If walking on ground and dig=1, start digging
        // 4) If walking and bump, switch direction
        // 5) Otherwise, remain

        if (!ground) begin
            // Start falling; digging stops
            next_state = {direction, 1'b1};
            digging_next = 1'b0;
        end else if (mode == 1'b1 && ground) begin
            // Was falling, ground returned => walk same direction, digging off
            next_state = {direction, 1'b0};
            digging_next = 1'b0;
        end else begin
            // Walking on ground
            if (digging_r) begin
                // Continue digging as long as ground present
                // If ground lost, handled above (fall)
                next_state = state; // walking and digging; direction and mode same
                digging_next = 1'b1;
            end else begin
                // Not digging
                if (dig) begin
                    // Start digging only if walking and ground present
                    next_state = state; // walking same state
                    digging_next = 1'b1;
                end else if (bump_left || bump_right) begin
                    // Direction changes on bump when walking and not digging
                    // If both bumps or either bump, flip direction
                    // Direction is bit1
                    if (bump_left && bump_right) begin
                        next_state = {~direction, 1'b0};
                    end else if (bump_left) begin
                        next_state = {1'b1, 1'b0}; // walk right
                    end else begin // bump_right
                        next_state = {1'b0, 1'b0}; // walk left
                    end
                    digging_next = 1'b0;
                end else begin
                    // No action, remain walking same direction, no digging
                    next_state = state;
                    digging_next = 1'b0;
                end
            end
        end
    end

    // Sequential logic with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            digging_r <= 1'b0;
        end else begin
            state <= next_state;
            digging_r <= digging_next;
        end
    end

    // Outputs (Moore FSM outputs)
    assign walk_left  = (mode == 1'b0) && (direction == 1'b0) && (digging_r == 1'b0);
    assign walk_right = (mode == 1'b0) && (direction == 1'b1) && (digging_r == 1'b0);
    assign aaah       = (mode == 1'b1);
    assign digging    = digging_r;

endmodule