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

    reg state;      // 0=WALK, 1=FALL
    reg direction;  // 0=left, 1=right

    always @(posedge clk, posedge areset) begin
        if (areset) begin
            state <= 0;
            direction <= 0;
        end else if (state) begin
            state <= ~ground;
        end else begin
            state <= ~ground;
            if (ground) begin
                if (bump_left) direction <= 1;
                if (bump_right) direction <= 0;
            end
        end
    end

    assign walk_left = ~state & ~direction;
    assign walk_right = ~state & direction;
    assign aaah = state;

endmodule