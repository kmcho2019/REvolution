module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output reg walk_left,
    output reg walk_right,
    output reg aaah
);

    reg direction;  // 0=left, 1=right
    reg falling;

    // Direction state machine (parallel to falling logic)
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            direction <= 0;  // start walking left
        end else if (!falling && ground) begin
            if ((direction && bump_right) || (!direction && bump_left)) begin
                direction <= ~direction;
            end
        end
    end

    // Falling state machine (parallel to direction logic)
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            falling <= 0;
        end else begin
            if (!falling && !ground) begin
                falling <= 1;
            end else if (falling && ground) begin
                falling <= 0;
            end
        end
    end

    // Registered outputs to reduce glitches
    always @(posedge clk, posedge areset) begin
        if (areset) begin
            walk_left <= 1;
            walk_right <= 0;
            aaah <= 0;
        end else begin
            walk_left <= ~falling & ~direction;
            walk_right <= ~falling & direction;
            aaah <= falling;
        end
    end

endmodule