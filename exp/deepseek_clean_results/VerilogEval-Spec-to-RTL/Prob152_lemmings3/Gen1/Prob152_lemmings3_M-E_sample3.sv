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

    // Direction states (persistent through actions)
    parameter DIR_LEFT = 1'b0;
    parameter DIR_RIGHT = 1'b1;
    reg direction;

    // Action states
    parameter ACT_WALK = 2'b00;
    parameter ACT_FALL = 2'b01;
    parameter ACT_DIG = 2'b10;
    reg [1:0] action;

    // Next state logic
    always @(*) begin
        // Default: maintain current state
        direction = direction;
        action = action;

        // Handle direction changes (only when walking)
        if (action == ACT_WALK && ground) begin
            if (bump_left) direction = DIR_RIGHT;
            if (bump_right) direction = DIR_LEFT;
        end

        // Handle action transitions (priority: fall > dig > walk)
        case (action)
            ACT_WALK: begin
                if (!ground) 
                    action = ACT_FALL;
                else if (dig) 
                    action = ACT_DIG;
            end
            ACT_FALL: begin
                if (ground) 
                    action = ACT_WALK;
            end
            ACT_DIG: begin
                if (!ground) 
                    action = ACT_FALL;
            end
        endcase
    end

    // State registers with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            direction <= DIR_LEFT;
            action <= ACT_WALK;
        end else begin
            direction <= direction;
            action <= action;
        end
    end

    // Output logic
    assign walk_left = (action == ACT_WALK) && (direction == DIR_LEFT);
    assign walk_right = (action == ACT_WALK) && (direction == DIR_RIGHT);
    assign aaah = (action == ACT_FALL);
    assign digging = (action == ACT_DIG);

endmodule