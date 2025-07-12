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

    // State definitions
    parameter WALK_LEFT = 1'b0;
    parameter WALK_RIGHT = 1'b1;
    
    reg walking_dir;  // Current walking direction
    reg falling;      // Falling state
    
    // Next state variables
    reg next_walking_dir;
    reg next_falling;
    
    // Combinational next state logic
    always @(*) begin
        // Default: keep current state
        next_walking_dir = walking_dir;
        next_falling = falling;
        
        if (!falling) begin
            if (!ground) begin
                next_falling = 1'b1;
            end
            else begin
                // Handle bump transitions
                case (walking_dir)
                    WALK_LEFT: if (bump_left) next_walking_dir = WALK_RIGHT;
                    WALK_RIGHT: if (bump_right) next_walking_dir = WALK_LEFT;
                endcase
            end
        end
        else begin
            if (ground) begin
                next_falling = 1'b0;
            end
        end
    end
    
    // Sequential state update
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            walking_dir <= WALK_LEFT;
            falling <= 1'b0;
        end
        else begin
            walking_dir <= next_walking_dir;
            falling <= next_falling;
        end
    end
    
    // Output logic
    assign walk_left = (walking_dir == WALK_LEFT) && !falling;
    assign walk_right = (walking_dir == WALK_RIGHT) && !falling;
    assign aaah = falling;

endmodule