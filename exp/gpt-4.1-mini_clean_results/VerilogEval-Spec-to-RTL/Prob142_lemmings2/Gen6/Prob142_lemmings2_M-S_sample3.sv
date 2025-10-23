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
    reg falling;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            direction <= 1'b0; // walk left
            falling   <= 1'b0; // not falling
        end else begin
            if (!ground) begin
                // start falling, direction unchanged
                falling <= 1'b1;
            end else if (falling) begin
                // ground returned, stop falling
                falling <= 1'b0;
            end else begin
                // walking and ground present
                if (bump_left || bump_right) begin
                    direction <= ~direction; // flip direction if bumped
                end
                // falling remains 0
            end
        end
    end

    assign walk_left  = (direction == 1'b0) && !falling;
    assign walk_right = (direction == 1'b1) && !falling;
    assign aaah       = falling;

endmodule