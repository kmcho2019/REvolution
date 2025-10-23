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
    reg ground_reg;   // Registered version of ground
    
    // Register ground signal to improve timing
    always @(posedge clk) begin
        ground_reg <= ground;
    end
    
    // State transitions with input gating
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
                    // Gate bump signals with !falling to reduce power
                    case (walking_dir)
                        LEFT: if (bump_left) walking_dir <= RIGHT;
                        RIGHT: if (bump_right) walking_dir <= LEFT;
                    endcase
                end
            end
        end
    end
    
    // Optimized output logic - single register drives both outputs
    assign walk_left = (~falling) & (~walking_dir);
    assign walk_right = (~falling) & walking_dir;
    assign aaah = falling;
endmodule