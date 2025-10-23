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
    reg direction;  // 0=left, 1=right
    reg falling;
    reg bump_left_prev, bump_right_prev;
    
    // Clock gating for falling state (reduces power)
    wire falling_clk_en = falling || !ground;
    wire falling_clk = falling_clk_en ? clk : 1'b0;
    
    // Falling state machine (minimized transitions)
    always @(posedge falling_clk, posedge areset) begin
        if (areset) begin
            falling <= 1'b0;
        end else begin
            falling <= !ground;
        end
    end
    
    // Direction state machine (optimized for timing)
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            direction <= 1'b0;
            bump_left_prev <= 1'b0;
            bump_right_prev <= 1'b0;
        end else begin
            // Edge detection for bumps (reduces power)
            bump_left_prev <= bump_left;
            bump_right_prev <= bump_right;
            
            // Only change direction when on ground and not falling
            if (!falling && ground) begin
                // XOR-based direction toggle (simpler logic)
                if ((direction ? (bump_right && !bump_right_prev) : 
                                (bump_left && !bump_left_prev))) begin
                    direction <= ~direction;
                end
            end
        end
    end
    
    // Output logic (merged with state where possible)
    assign walk_left = ~falling & ~direction;
    assign walk_right = ~falling & direction;
    assign aaah = falling;
endmodule