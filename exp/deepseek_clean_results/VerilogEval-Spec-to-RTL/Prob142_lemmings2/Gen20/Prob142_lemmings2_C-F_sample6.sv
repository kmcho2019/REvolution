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
    reg falling;    // 1 when falling

    always @(posedge clk, posedge areset) begin
        if (areset) begin
            direction <= 0;  // start walking left
            falling <= 0;
        end else begin
            if (falling) begin
                if (ground) falling <= 0;
            end else begin
                if (!ground) begin
                    falling <= 1;
                end else if ((direction && bump_right) || (!direction && bump_left)) begin
                    direction <= ~direction;
                end
            end
        end
    end

    assign walk_left = ~falling & ~direction;
    assign walk_right = ~falling & direction;
    assign aaah = falling;

endmodule