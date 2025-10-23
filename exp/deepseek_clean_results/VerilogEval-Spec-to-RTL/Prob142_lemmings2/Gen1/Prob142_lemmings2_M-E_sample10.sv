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

    // State tracking: 0=left, 1=right
    reg walking_dir;
    reg falling;
    
    // Next state logic
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            walking_dir <= 0;  // Start walking left
            falling <= 0;
        end
        else begin
            if (!falling) begin
                // Only process bumps and ground when not falling
                if (!ground) begin
                    falling <= 1;
                end
                else begin
                    // Process bumps only when on ground
                    if ((walking_dir == 0 && bump_left) || 
                         (walking_dir == 1 && bump_right)) begin
                        walking_dir <= ~walking_dir;
                    end
                end
            end
            else begin
                // When falling, only check ground
                if (ground) begin
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