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

    // Registered inputs to improve timing
    reg bump_left_reg, bump_right_reg;
    reg ground_reg;
    
    // State tracking: 0=left, 1=right
    reg walking_dir;
    reg falling;
    
    // Clock gating signal
    wire clk_en = areset || (falling ? !ground_reg : 1'b1);
    wire gated_clk = clk & clk_en;
    
    // Input registration
    always @(posedge clk) begin
        bump_left_reg <= bump_left;
        bump_right_reg <= bump_right;
        ground_reg <= ground;
    end
    
    // State machine with gated clock
    always @(posedge gated_clk, posedge areset) begin
        if (areset) begin
            walking_dir <= 0;  // Start walking left
            falling <= 0;
        end
        else begin
            if (!falling) begin
                // Only process bumps and ground when not falling
                if (!ground_reg) begin
                    falling <= 1;
                end
                else if ((walking_dir == 0 && bump_left_reg) || 
                        (walking_dir == 1 && bump_right_reg)) begin
                    walking_dir <= ~walking_dir;
                end
            end
            else begin
                // When falling, only check ground
                if (ground_reg) begin
                    falling <= 0;
                end
            end
        end
    end
    
    // Output logic
    assign walk_left = (~walking_dir) & (~falling);
    assign walk_right = walking_dir & (~falling);
    assign aaah = falling;

endmodule