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
    reg dir;  // 0=LEFT, 1=RIGHT
    reg falling;
    
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            dir <= 0;
            falling <= 0;
        end
        else if (falling) begin
            falling <= ~ground;
        end
        else if (~ground) begin
            falling <= 1;
        end
        else begin
            case (dir)
                0: if (bump_left) dir <= 1;
                1: if (bump_right) dir <= 0;
            endcase
        end
    end
    
    assign walk_left = ~falling & ~dir;
    assign walk_right = ~falling & dir;
    assign aaah = falling;
endmodule