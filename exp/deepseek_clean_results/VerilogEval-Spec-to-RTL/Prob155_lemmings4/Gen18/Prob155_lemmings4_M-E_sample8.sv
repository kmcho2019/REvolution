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
    parameter ACT_WALK = 2'b00;
    parameter ACT_DIG  = 2'b01;
    parameter ACT_FALL = 2'b10;
    parameter ACT_SPLAT = 2'b11;
    
    // Direction states
    parameter DIR_LEFT = 1'b0;
    parameter DIR_RIGHT = 1'b1;
    
    reg [1:0] action_state, next_action;
    reg direction, next_dir;
    reg [4:0] fall_counter;
    reg dir_shadow;  // Shadow copy of direction
    
    // Event detection with priority encoding
    wire start_fall = !ground && (action_state == ACT_WALK || action_state == ACT_DIG);
    wire start_dig = ground && dig && action_state == ACT_WALK && !start_fall;
    wire should_switch = (action_state == ACT_WALK) && 
                        ((direction == DIR_LEFT && bump_left) || 
                         (direction == DIR_RIGHT && bump_right) ||
                         (bump_left && bump_right)) && 
                        !start_fall && !start_dig;
    
    // Next state logic
    always @(*) begin
        // Defaults
        next_action = action_state;
        next_dir = direction;
        
        // Priority-based state transitions
        case (action_state)
            ACT_WALK: begin
                if (start_fall) begin
                    next_action = ACT_FALL;
                    dir_shadow = direction;
                end else if (start_dig) begin
                    next_action = ACT_DIG;
                    dir_shadow = direction;
                end else if (should_switch) begin
                    next_dir = ~direction;
                end
            end
            
            ACT_DIG: begin
                if (start_fall) begin
                    next_action = ACT_FALL;
                end
            end
            
            ACT_FALL: begin
                if (ground) begin
                    next_action = (fall_counter > 20) ? ACT_SPLAT : ACT_WALK;
                    next_dir = dir_shadow;
                end
            end
            
            ACT_SPLAT: begin
                next_action = ACT_SPLAT;
            end
        endcase
    end
    
    // Sequential logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            action_state <= ACT_WALK;
            direction <= DIR_LEFT;
            dir_shadow <= DIR_LEFT;
            fall_counter <= 0;
        end else begin
            action_state <= next_action;
            direction <= next_dir;
            
            // Update fall counter
            if (action_state == ACT_FALL) begin
                if (next_action != ACT_FALL) begin
                    fall_counter <= 0;
                end else begin
                    fall_counter <= fall_counter + 1;
                end
            end else begin
                fall_counter <= 0;
            end
        end
    end
    
    // Output logic
    assign walk_left = (action_state == ACT_WALK) && (direction == DIR_LEFT);
    assign walk_right = (action_state == ACT_WALK) && (direction == DIR_RIGHT);
    assign aaah = (action_state == ACT_FALL);
    assign digging = (action_state == ACT_DIG);
    
endmodule