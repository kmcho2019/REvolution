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
    reg direction;  // 0: left, 1: right

    // Action states
    parameter WALK = 2'b00;
    parameter FALL = 2'b01;
    parameter DIG  = 2'b10;
    reg [1:0] action_state, next_action;

    // State transition logic
    always @(*) begin
        case (action_state)
            WALK: begin
                if (~ground)
                    next_action = FALL;
                else if (dig)
                    next_action = DIG;
                else
                    next_action = WALK;
            end
            FALL: begin
                if (ground)
                    next_action = WALK;
                else
                    next_action = FALL;
            end
            DIG: begin
                if (~ground)
                    next_action = FALL;
                else
                    next_action = DIG;
            end
            default: next_action = WALK;
        endcase
    end

    // Direction update logic (only when walking)
    always @(*) begin
        if (action_state == WALK && next_action == WALK) begin
            if (bump_left)
                direction = 1'b1;  // switch to right
            else if (bump_right)
                direction = 1'b0;  // switch to left
        end
    end

    // State registers with asynchronous reset
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            direction <= 1'b0;  // start walking left
            action_state <= WALK;
        end else begin
            action_state <= next_action;
            // Direction only updates when walking and not changing to fall/dig
            if (action_state == WALK && next_action == WALK) begin
                if (bump_left)
                    direction <= 1'b1;
                else if (bump_right)
                    direction <= 1'b0;
            end
        end
    end

    // Output logic
    assign walk_left = (action_state == WALK) & ~direction;
    assign walk_right = (action_state == WALK) & direction;
    assign aaah = (action_state == FALL);
    assign digging = (action_state == DIG);

endmodule