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
    
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            direction <= 1'b0;
            falling <= 1'b0;
        end
        else begin
            // Handle falling state first
            if (!ground) begin
                falling <= 1'b1;
            end
            else if (falling) begin
                falling <= 1'b0;
            end
            // Handle direction changes only when on ground and not falling
            else if ((direction & bump_right) | (!direction & bump_left)) begin
                direction <= ~direction;
            end
        end
    end
    
    assign walk_left = ~falling & ~direction;
    assign walk_right = ~falling & direction;
    assign aaah = falling;
endmodule