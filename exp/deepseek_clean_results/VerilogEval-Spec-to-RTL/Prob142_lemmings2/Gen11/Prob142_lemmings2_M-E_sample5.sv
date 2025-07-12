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
    parameter WALK = 1'b0;
    parameter FALL = 1'b1;
    
    // Direction states
    parameter LEFT = 1'b0;
    parameter RIGHT = 1'b1;
    
    reg main_state, next_main;
    reg direction, next_dir;
    
    // Edge detection registers
    reg bump_left_prev, bump_right_prev;
    wire bump_left_edge = bump_left && !bump_left_prev;
    wire bump_right_edge = bump_right && !bump_right_prev;
    
    // State transition logic
    always @(*) begin
        next_main = main_state;
        next_dir = direction;
        
        case (main_state)
            WALK: begin
                if (!ground) begin
                    next_main = FALL;
                end
                else begin
                    // Only change direction on edge detection
                    if (direction == LEFT && bump_left_edge) begin
                        next_dir = RIGHT;
                    end
                    else if (direction == RIGHT && bump_right_edge) begin
                        next_dir = LEFT;
                    end
                end
            end
            FALL: begin
                if (ground) begin
                    next_main = WALK;
                end
            end
        endcase
    end
    
    // Sequential logic with async reset
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            main_state <= WALK;
            direction <= LEFT;
            bump_left_prev <= 0;
            bump_right_prev <= 0;
        end
        else begin
            main_state <= next_main;
            
            // Only update direction when walking and ground is present
            if (main_state == WALK && ground) begin
                direction <= next_dir;
            end
            
            // Store previous bump values for edge detection
            bump_left_prev <= bump_left;
            bump_right_prev <= bump_right;
        end
    end
    
    // Output logic
    assign walk_left = (main_state == WALK) && (direction == LEFT);
    assign walk_right = (main_state == WALK) && (direction == RIGHT);
    assign aaah = (main_state == FALL);

endmodule