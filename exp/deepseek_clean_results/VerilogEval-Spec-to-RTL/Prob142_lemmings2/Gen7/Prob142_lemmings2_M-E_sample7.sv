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
    reg prev_bump_left, prev_bump_right;
    
    // Edge detection for bump signals
    wire bump_left_edge = bump_left & ~prev_bump_left;
    wire bump_right_edge = bump_right & ~prev_bump_right;
    
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            direction <= 1'b0;
            falling <= 1'b0;
            prev_bump_left <= 1'b0;
            prev_bump_right <= 1'b0;
        end
        else begin
            // Store previous bump values for edge detection
            prev_bump_left <= bump_left;
            prev_bump_right <= bump_right;
            
            // Falling state has priority
            if (falling) begin
                if (ground) falling <= 1'b0;
            end
            else if (!ground) begin
                falling <= 1'b1;
            end
            // Only process direction changes when not falling
            else if (!falling) begin
                if (direction ? bump_right_edge : bump_left_edge) begin
                    direction <= ~direction;
                end
            end
        end
    end
    
    assign walk_left = ~falling & ~direction;
    assign walk_right = ~falling & direction;
    assign aaah = falling;
endmodule