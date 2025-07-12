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

    reg walking_left;  // 1 for left, 0 for right
    reg falling;

    always @(posedge clk, posedge areset) begin
        if (areset) begin
            walking_left <= 1'b1;
            falling <= 1'b0;
        end
        else if (falling) begin
            if (ground) falling <= 1'b0;
        end
        else begin
            if (~ground) begin
                falling <= 1'b1;
            end
            else if ((walking_left && bump_left) || (~walking_left && bump_right)) begin
                walking_left <= ~walking_left;
            end
        end
    end

    assign walk_left = ~falling & walking_left;
    assign walk_right = ~falling & ~walking_left;
    assign aaah = falling;

endmodule