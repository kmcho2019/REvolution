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
    parameter DIR_LEFT = 1'b1;
    parameter DIR_RIGHT = 1'b0;
    reg direction;

    // Action states
    parameter ACT_WALK = 2'b00;
    parameter ACT_FALL = 2'b01;
    parameter ACT_DIG = 2'b10;
    reg [1:0] action;

    // Next state logic - direction (independent of action)
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            direction <= DIR_LEFT;
        end else if (action == ACT_WALK) begin
            case ({bump_left, bump_right})
                2'b10: direction <= DIR_RIGHT;
                2'b01: direction <= DIR_LEFT;
                2'b11: direction <= ~direction;
                default: direction <= direction;
            endcase
        end
    end

    // Next state logic - action (priority ordered)
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            action <= ACT_WALK;
        end else begin
            // Highest priority: falling
            if (~ground) begin
                action <= ACT_FALL;
            end
            // Second priority: landing from fall
            else if (action == ACT_FALL) begin
                action <= ACT_WALK;
            end
            // Third priority: start digging
            else if (dig && action == ACT_WALK) begin
                action <= ACT_DIG;
            end
            // Fourth priority: stop digging when ground lost
            else if (action == ACT_DIG && ~ground) begin
                action <= ACT_FALL;
            end
        end
    end

    // Output logic - pure Moore
    assign walk_left = (direction == DIR_LEFT) && (action == ACT_WALK);
    assign walk_right = (direction == DIR_RIGHT) && (action == ACT_WALK);
    assign aaah = (action == ACT_FALL);
    assign digging = (action == ACT_DIG);

endmodule