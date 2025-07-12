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

    reg walking;    // 1=walking, 0=falling
    reg dir;        // 0=left, 1=right

    always @(posedge clk, posedge areset) begin
        if (areset) begin
            walking <= 1;
            dir <= 0;
        end
        else if (walking) begin
            if (!ground) begin
                walking <= 0;
            end
            else if ((!dir && bump_left) || (dir && bump_right)) begin
                dir <= ~dir;
            end
        end
        else if (ground) begin
            walking <= 1;
        end
    end

    assign walk_left = walking && !dir;
    assign walk_right = walking && dir;
    assign aaah = !walking;

endmodule