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
            direction <= 1'b0;  // Start walking left
            falling <= 1'b0;
        end else begin
            // Update falling state
            falling <= ~ground;
            
            // Update direction only when not falling
            if (~falling && ground) begin
                if (direction && bump_right)
                    direction <= 1'b0;
                else if (~direction && bump_left)
                    direction <= 1'b1;
            end
        end
    end

    assign walk_left = ~falling & ~direction;
    assign walk_right = ~falling & direction;
    assign aaah = falling;

endmodule