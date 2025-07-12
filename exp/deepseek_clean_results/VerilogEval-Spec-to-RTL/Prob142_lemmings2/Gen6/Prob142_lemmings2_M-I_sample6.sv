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
    reg ground_reg, ground_prev;
    
    // State tracking: 0=left, 1=right
    reg walking_dir;
    reg falling;
    
    // Clock gating signals
    wire state_update_en = (falling ? (ground_reg != ground_prev) : 1'b1);
    wire dir_update_en = !falling && ground_reg;
    
    // Input registration
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            bump_left_reg <= 0;
            bump_right_reg <= 0;
            ground_reg <= 1;
            ground_prev <= 1;
        end else begin
            bump_left_reg <= bump_left;
            bump_right_reg <= bump_right;
            ground_prev <= ground_reg;
            ground_reg <= ground;
        end
    end
    
    // State machine with clock gating
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            walking_dir <= 0;  // Start walking left
            falling <= 0;
        end
        else if (state_update_en) begin
            if (!falling) begin
                // Only process ground transitions when not falling
                if (!ground_reg) begin
                    falling <= 1;
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
    
    // Direction update with separate always block for better timing
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            walking_dir <= 0;
        end
        else if (dir_update_en) begin
            // Process bumps only when on ground and not falling
            if ((walking_dir == 0 && bump_left_reg) || 
                (walking_dir == 1 && bump_right_reg)) begin
                walking_dir <= ~walking_dir;
            end
        end
    end
    
    // Output logic
    assign walk_left = (~walking_dir) & (~falling);
    assign walk_right = walking_dir & (~falling);
    assign aaah = falling;

endmodule