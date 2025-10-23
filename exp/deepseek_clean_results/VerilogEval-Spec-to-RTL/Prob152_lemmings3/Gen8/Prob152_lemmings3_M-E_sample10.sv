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
    // Action states
    parameter WALK = 2'b00;
    parameter FALL = 2'b01;
    parameter DIG  = 2'b10;
    
    reg [1:0] action_state, next_action;
    reg direction, next_direction;
    reg pending_direction_change;
    
    // State transitions
    always @(*) begin
        next_action = action_state;
        next_direction = direction;
        pending_direction_change = 1'b0;
        
        case (action_state)
            WALK: begin
                if (~ground) begin
                    next_action = FALL;
                end else if (dig) begin
                    next_action = DIG;
                end else begin
                    // Buffer direction changes if both bumps occur
                    if (bump_left && ~direction) begin
                        pending_direction_change = 1'b1;
                        next_direction = 1'b1;
                    end else if (bump_right && direction) begin
                        pending_direction_change = 1'b1;
                        next_direction = 1'b0;
                    end
                end
            end
            
            FALL: begin
                if (ground) begin
                    next_action = WALK;
                end
            end
            
            DIG: begin
                if (~ground) begin
                    next_action = FALL;
                end
            end
        endcase
    end
    
    // State updates
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            action_state <= WALK;
            direction <= 1'b0;
        end else begin
            action_state <= next_action;
            // Only update direction if we're walking and have a pending change
            if (action_state == WALK && pending_direction_change) begin
                direction <= next_direction;
            end
        end
    end
    
    // Output logic
    assign walk_left  = (action_state == WALK) && ~direction;
    assign walk_right = (action_state == WALK) && direction;
    assign aaah       = (action_state == FALL);
    assign digging    = (action_state == DIG);
    
endmodule