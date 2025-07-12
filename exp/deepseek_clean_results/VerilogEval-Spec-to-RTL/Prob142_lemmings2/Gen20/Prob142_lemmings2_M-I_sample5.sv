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
    wire change_dir; // Combinational direction change signal

    // Pre-compute direction change condition
    assign change_dir = (direction ? bump_right : bump_left) & ground & ~falling;

    always @(posedge clk, posedge areset) begin
        if (areset) begin
            direction <= 0;  // start walking left
            falling <= 0;
        end else begin
            if (!ground) begin
                falling <= 1;
            end else if (falling) begin
                falling <= 0;
            end else if (change_dir) begin
                direction <= ~direction;
            end
        end
    end

    // Shared term optimization
    wire not_falling = ~falling;
    assign walk_left = not_falling & ~direction;
    assign walk_right = not_falling & direction;
    assign aaah = falling;

endmodule