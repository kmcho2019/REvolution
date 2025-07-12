module TopModule(
    input  wire clk,
    input  wire areset,
    input  wire bump_left,
    input  wire bump_right,
    input  wire ground,
    output wire walk_left,
    output wire walk_right,
    output wire aaah
);

    reg direction; // 0 = left, 1 = right
    reg falling;   // 0 = walking, 1 = falling

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            direction <= 1'b0; // walk left
            falling <= 1'b0;   // not falling
        end else begin
            if (!ground) begin
                falling <= 1'b1; // start or continue falling
            end else if (falling) begin
                falling <= 1'b0; // stop falling when ground returns
            end

            if (!falling && ground) begin
                // update direction only when walking and grounded
                if (bump_left && bump_right) begin
                    direction <= ~direction; // flip direction
                end else if (bump_left) begin
                    direction <= 1'b1; // walk right
                end else if (bump_right) begin
                    direction <= 1'b0; // walk left
                end
            end
        end
    end

    assign walk_left  = (direction == 1'b0) && !falling;
    assign walk_right = (direction == 1'b1) && !falling;
    assign aaah       = falling;

endmodule