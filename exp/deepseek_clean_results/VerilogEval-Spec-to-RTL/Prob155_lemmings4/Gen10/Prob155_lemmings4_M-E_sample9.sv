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
    localparam DIR_LEFT = 1'b0;
    localparam DIR_RIGHT = 1'b1;
    reg direction;

    // Activity states
    localparam ACT_WALK = 2'b00;
    localparam ACT_FALL = 2'b01;
    localparam ACT_DIG  = 2'b10;
    localparam ACT_SPLATTER = 2'b11;
    reg [1:0] activity, next_activity;

    reg [4:0] fall_timer;

    // Direction FSM
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            direction <= DIR_LEFT;
        end else if (activity == ACT_WALK) begin
            // Only change direction when walking normally
            case ({bump_left, bump_right})
                2'b10: direction <= DIR_RIGHT;
                2'b01: direction <= DIR_LEFT;
                2'b11: direction <= ~direction; // Both bumps - toggle direction
                default: direction <= direction;
            endcase
        end
    end

    // Activity FSM transition
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            activity <= ACT_WALK;
            fall_timer <= 0;
        end else begin
            activity <= next_activity;
            
            // Update fall timer
            if (activity == ACT_FALL && !ground)
                fall_timer <= fall_timer + 1;
            else
                fall_timer <= 0;
        end
    end

    // Activity FSM next state logic
    always @(*) begin
        case (activity)
            ACT_WALK: begin
                if (!ground)
                    next_activity = ACT_FALL; // Fall has highest priority
                else if (dig)
                    next_activity = ACT_DIG; // Dig comes next
                else
                    next_activity = ACT_WALK;
            end
            
            ACT_FALL: begin
                if (ground)
                    next_activity = (fall_timer > 20) ? ACT_SPLATTER : ACT_WALK;
                else
                    next_activity = ACT_FALL;
            end
            
            ACT_DIG: begin
                if (!ground)
                    next_activity = ACT_FALL;
                else
                    next_activity = ACT_DIG;
            end
            
            ACT_SPLATTER: next_activity = ACT_SPLATTER;
            
            default: next_activity = ACT_WALK;
        endcase
    end

    // Output logic
    assign walk_left = (activity == ACT_WALK) && (direction == DIR_LEFT);
    assign walk_right = (activity == ACT_WALK) && (direction == DIR_RIGHT);
    assign aaah = (activity == ACT_FALL);
    assign digging = (activity == ACT_DIG);

endmodule