module TopModule (
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

    // Movement direction states
    parameter DIR_LEFT = 1'b0;
    parameter DIR_RIGHT = 1'b1;
    reg direction;

    // Action states
    parameter [1:0] 
        ACT_WALK = 2'b00,
        ACT_FALL = 2'b01,
        ACT_DIG  = 2'b10,
        ACT_SPLAT = 2'b11;
    reg [1:0] action;

    // Fall timer
    reg [4:0] fall_cycles;

    // Next state logic
    always @(*) begin
        // Default: maintain current state
        direction = direction;
        action = action;

        if (action == ACT_SPLAT) begin
            // Stay in splat state forever
            action = ACT_SPLAT;
        end
        else if (~ground && (action == ACT_WALK || action == ACT_DIG)) begin
            // Priority 1: Falling (when ground disappears)
            action = ACT_FALL;
            fall_cycles = 0;
        end
        else if (ground && action == ACT_FALL) begin
            // Landed after falling
            if (fall_cycles > 20) begin
                action = ACT_SPLAT;
            end else begin
                action = ACT_WALK;
            end
        end
        else if (action == ACT_WALK && dig && ground) begin
            // Priority 2: Digging (when in walking state)
            action = ACT_DIG;
        end
        else if (action == ACT_WALK) begin
            // Priority 3: Bump handling
            if (bump_left && direction == DIR_LEFT) begin
                direction = DIR_RIGHT;
            end
            else if (bump_right && direction == DIR_RIGHT) begin
                direction = DIR_LEFT;
            end
        end
        else if (action == ACT_DIG && ~ground) begin
            // Digging through to falling
            action = ACT_FALL;
            fall_cycles = 0;
        end
    end

    // Sequential logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            direction <= DIR_LEFT;
            action <= ACT_WALK;
            fall_cycles <= 0;
        end else begin
            // Update direction and action states
            if (action != ACT_SPLAT) begin
                direction <= direction;
                action <= action;
            end

            // Update fall timer
            if (action == ACT_FALL && ~ground) begin
                fall_cycles <= fall_cycles + 1;
            end else begin
                fall_cycles <= 0;
            end
        end
    end

    // Output logic
    assign walk_left = (action == ACT_WALK) && (direction == DIR_LEFT);
    assign walk_right = (action == ACT_WALK) && (direction == DIR_RIGHT);
    assign aaah = (action == ACT_FALL);
    assign digging = (action == ACT_DIG);

endmodule