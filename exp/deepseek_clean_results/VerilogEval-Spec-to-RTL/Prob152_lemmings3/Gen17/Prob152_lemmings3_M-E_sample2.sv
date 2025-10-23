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
    reg direction; // 0=left, 1=right

    // Action states
    parameter WALK = 2'b00;
    parameter FALL = 2'b01;
    parameter DIG  = 2'b10;
    reg [1:0] action_state;

    // Direction update logic (only when walking on ground)
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            direction <= 0;
        end
        else if (action_state == WALK && ground && !dig) begin
            if (bump_left) direction <= 1;
            if (bump_right) direction <= 0;
        end
    end

    // Action state transitions
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            action_state <= WALK;
        end
        else begin
            case (action_state)
                WALK: begin
                    if (!ground) action_state <= FALL;
                    else if (dig) action_state <= DIG;
                end
                
                FALL: if (ground) action_state <= WALK;
                
                DIG: if (!ground) action_state <= FALL;
            endcase
        end
    end

    // Output logic
    assign walk_left  = (action_state == WALK) && !direction;
    assign walk_right = (action_state == WALK) && direction;
    assign aaah       = (action_state == FALL);
    assign digging    = (action_state == DIG);

endmodule