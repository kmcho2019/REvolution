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
    reg dir;  // 0=left, 1=right
    reg falling;
    
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            dir <= 0;
            falling <= 0;
        end
        else if (falling) begin
            if (ground) falling <= 0;
        end
        else if (!ground) begin
            falling <= 1;
        end
        else if (dir ? bump_right : bump_left) begin
            dir <= ~dir;
        end
    end
    
    assign walk_left = ~falling & ~dir;
    assign walk_right = ~falling & dir;
    assign aaah = falling;
endmodule