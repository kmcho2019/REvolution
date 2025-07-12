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
    // State encoding
    parameter LEFT = 1'b0;
    parameter RIGHT = 1'b1;
    
    reg walking_dir;  // LEFT or RIGHT
    reg falling;
    reg ground_reg;
    reg bump_left_reg, bump_right_reg;
    
    // Register inputs for timing and hysteresis
    always @(posedge clk) begin
        ground_reg <= ground;
        bump_left_reg <= bump_left;
        bump_right_reg <= bump_right;
    end
    
    // State transitions with hysteresis
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            walking_dir <= LEFT;
            falling <= 0;
        end
        else begin
            if (falling) begin
                // Only check ground while falling
                if (ground_reg) falling <= 0;
            end
            else begin
                // Handle walking state transitions
                if (!ground_reg) begin
                    falling <= 1;
                end
                else begin
                    // Only change direction if bump persists for one cycle
                    case (walking_dir)
                        LEFT: if (bump_left_reg) walking_dir <= RIGHT;
                        RIGHT: if (bump_right_reg) walking_dir <= LEFT;
                    endcase
                end
            end
        end
    end
    
    // Output logic - optimized Moore style
    assign walk_left = (~falling) & (~walking_dir);
    assign walk_right = (~falling) & walking_dir;
    assign aaah = falling;
endmodule