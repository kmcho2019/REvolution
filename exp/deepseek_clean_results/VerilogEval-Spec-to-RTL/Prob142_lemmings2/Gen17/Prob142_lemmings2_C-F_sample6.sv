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

    reg walking;    // 1=WALK, 0=FALL
    reg direction;  // 0=left, 1=right

    always @(posedge clk, posedge areset) begin
        if (areset) begin
            walking <= 1;
            direction <= 0;
        end
        else begin
            if (walking) begin
                if (!ground) begin
                    walking <= 0;
                end
                else if ((bump_left && !direction) || (bump_right && direction)) begin
                    direction <= ~direction;
                end
            end
            else if (ground) begin
                walking <= 1;
            end
        end
    end

    assign walk_left = walking & ~direction;
    assign walk_right = walking & direction;
    assign aaah = ~walking;

endmodule