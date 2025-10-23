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

    always @(posedge clk, posedge areset) begin
        if (areset) begin
            direction <= 0;  // Start walking left
        end
        else if (ground) begin  // Only change direction when on ground
            if ((!direction && bump_left) || (direction && bump_right))
                direction <= ~direction;
        end
    end

    assign walk_left = ground & ~direction;
    assign walk_right = ground & direction;
    assign aaah = ~ground;

endmodule