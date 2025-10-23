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
    reg falling;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            direction <= 1'b0; // walk left
            falling <= 1'b0;
        end else begin
            if (falling) begin
                // Falling: stop falling if ground returns, keep direction
                falling <= ~ground ? 1'b1 : 1'b0;
            end else begin
                // Walking: start falling if ground lost
                falling <= ground ? 1'b0 : 1'b1;

                // Change direction only if bumped while walking and ground present
                if (ground && (bump_left || bump_right)) begin
                    if (bump_left && bump_right)
                        direction <= ~direction;
                    else if (bump_left)
                        direction <= 1'b1; // walk right
                    else if (bump_right)
                        direction <= 1'b0; // walk left
                end
            end
        end
    end

    assign aaah       = falling;
    assign walk_left  = ~falling & ~direction;
    assign walk_right = ~falling &  direction;

endmodule