module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah
);
    // Main states
    parameter WALKING = 1'b0;
    parameter FALLING = 1'b1;
    
    // Direction states
    parameter LEFT = 1'b0;
    parameter RIGHT = 1'b1;
    
    reg main_state;
    reg direction;
    reg bump_left_prev, bump_right_prev;
    
    // Edge detection for bump signals
    wire bump_left_edge = bump_left & ~bump_left_prev;
    wire bump_right_edge = bump_right & ~bump_right_prev;
    
    // State transitions
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            main_state <= WALKING;
            direction <= LEFT;
            bump_left_prev <= 0;
            bump_right_prev <= 0;
        end
        else begin
            // Store previous bump signals for edge detection
            bump_left_prev <= bump_left;
            bump_right_prev <= bump_right;
            
            case (main_state)
                WALKING: begin
                    if (!ground) begin
                        main_state <= FALLING;
                    end
                    else begin
                        // Handle direction changes only when walking on ground
                        case (direction)
                            LEFT: if (bump_left_edge) direction <= RIGHT;
                            RIGHT: if (bump_right_edge) direction <= LEFT;
                        endcase
                    end
                end
                
                FALLING: begin
                    if (ground) begin
                        main_state <= WALKING;
                    end
                end
            endcase
        end
    end
    
    // Output logic
    assign walk_left = (main_state == WALKING) & (direction == LEFT);
    assign walk_right = (main_state == WALKING) & (direction == RIGHT);
    assign aaah = (main_state == FALLING);
endmodule