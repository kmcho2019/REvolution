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

    // Direction states
    parameter DIR_LEFT = 1'b0;
    parameter DIR_RIGHT = 1'b1;
    
    // Action states
    parameter ACTION_WALK = 2'd0;
    parameter ACTION_FALL = 2'd1;
    parameter ACTION_DIG = 2'd2;

    reg direction;      // Current direction (LEFT/RIGHT)
    reg [1:0] action;   // Current action (WALK/FALL/DIG)

    // Next state logic
    always @(*) begin
        if (action == ACTION_FALL) begin
            // In fall state - only check ground
            if (ground) begin
                action = ACTION_WALK;  // Return to walking
                // Direction remains same
            end else begin
                action = ACTION_FALL;  // Keep falling
            end
        end else if (!ground) begin
            // Highest priority: start falling
            action = ACTION_FALL;
            // Direction remains same
        end else if (action == ACTION_WALK && dig) begin
            // Can only start digging if walking on ground
            action = ACTION_DIG;
            // Direction remains same
        end else if (action == ACTION_WALK) begin
            // Handle direction changes only when walking
            if (direction == DIR_LEFT && bump_left) begin
                direction = DIR_RIGHT;
            end else if (direction == DIR_RIGHT && bump_right) begin
                direction = DIR_LEFT;
            end
            action = ACTION_WALK;  // Continue walking
        end else if (action == ACTION_DIG) begin
            // Keep digging until ground disappears
            action = ACTION_DIG;
        end
    end

    // State register
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            direction <= DIR_LEFT;
            action <= ACTION_WALK;
        end else begin
            direction <= direction;
            action <= action;
        end
    end

    // Output logic
    assign walk_left = (action == ACTION_WALK || action == ACTION_DIG) && (direction == DIR_LEFT);
    assign walk_right = (action == ACTION_WALK || action == ACTION_DIG) && (direction == DIR_RIGHT);
    assign aaah = (action == ACTION_FALL);
    assign digging = (action == ACTION_DIG);

endmodule