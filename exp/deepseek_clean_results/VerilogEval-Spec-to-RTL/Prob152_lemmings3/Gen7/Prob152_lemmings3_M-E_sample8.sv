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

    // Main states
    parameter MOVING = 0;
    parameter FALLING = 1;
    
    // Sub-states for MOVING
    parameter WALK = 0;
    parameter DIGGING = 1;
    
    reg main_state;
    reg moving_substate;
    reg direction;  // 0=left, 1=right
    reg prev_ground;
    
    // Edge detection for ground signal
    wire ground_falling_edge = (prev_ground && !ground);
    wire ground_rising_edge = (!prev_ground && ground);
    
    // Next state logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            main_state <= MOVING;
            moving_substate <= WALK;
            direction <= 0;
            prev_ground <= 1;
        end else begin
            prev_ground <= ground;
            
            case (main_state)
                MOVING: begin
                    if (ground_falling_edge) begin
                        main_state <= FALLING;
                    end else if (dig && ground && moving_substate == WALK) begin
                        moving_substate <= DIGGING;
                    end else if (moving_substate == DIGGING && !ground) begin
                        main_state <= FALLING;
                    end else if (moving_substate == WALK) begin
                        // Handle direction changes only when walking
                        if (bump_left && !direction) begin
                            direction <= 1;
                        end else if (bump_right && direction) begin
                            direction <= 0;
                        end
                    end
                end
                
                FALLING: begin
                    if (ground_rising_edge) begin
                        main_state <= MOVING;
                        moving_substate <= WALK;
                    end
                end
            endcase
        end
    end

    // Output logic
    assign walk_left = (main_state == MOVING) && (moving_substate == WALK) && !direction;
    assign walk_right = (main_state == MOVING) && (moving_substate == WALK) && direction;
    assign aaah = (main_state == FALLING);
    assign digging = (main_state == MOVING) && (moving_substate == DIGGING);

endmodule