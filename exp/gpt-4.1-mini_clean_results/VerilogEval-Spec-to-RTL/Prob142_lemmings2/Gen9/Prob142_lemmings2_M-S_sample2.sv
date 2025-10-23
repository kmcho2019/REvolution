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
    reg direction; // 0=left, 1=right
    reg falling;   // 0=walking, 1=falling

    wire bump = bump_left | bump_right;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            direction <= 1'b0; // walk left on reset
            falling <= 1'b0;   // start walking
        end else if (falling) begin
            if (ground) falling <= 1'b0; // stop falling when ground returns
        end else begin
            if (!ground) begin
                falling <= 1'b1; // start falling
            end else if (bump) begin
                if (bump_left & bump_right)
                    direction <= ~direction;
                else if (bump_left)
                    direction <= 1'b1; // walk right
                else
                    direction <= 1'b0; // walk left
            end
        end
    end

    assign walk_left  = (direction == 1'b0) && (falling == 1'b0);
    assign walk_right = (direction == 1'b1) && (falling == 1'b0);
    assign aaah       = falling;

endmodule