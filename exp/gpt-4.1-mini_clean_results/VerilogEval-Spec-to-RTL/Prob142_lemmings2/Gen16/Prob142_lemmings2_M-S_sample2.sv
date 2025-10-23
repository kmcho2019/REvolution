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

    reg falling, direction; // direction: 0=left, 1=right

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            falling   <= 1'b0;  // walking
            direction <= 1'b0;  // walk left
        end else begin
            if (!falling) begin
                // currently walking
                if (!ground) begin
                    // start falling, keep direction
                    falling <= 1'b1;
                end else begin
                    // walking on ground
                    if (bump_left && bump_right) begin
                        direction <= ~direction;
                    end else if (bump_left) begin
                        direction <= 1'b1; // walk right
                    end else if (bump_right) begin
                        direction <= 1'b0; // walk left
                    end
                end
            end else begin
                // currently falling
                if (ground) begin
                    // ground reappeared, resume walking
                    falling <= 1'b0;
                end
                // else keep falling and same direction
            end
        end
    end

    // Moore outputs
    assign aaah       = falling;
    assign walk_left  = ~falling & ~direction;
    assign walk_right = ~falling & direction;

endmodule