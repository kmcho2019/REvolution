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
        end else if (!state) begin
            if (!ground) begin
                state <= 1;
            end else if (bump_left ^ bump_right) begin
                if (bump_left) direction <= 1;
                if (bump_right) direction <= 0;
            end
        end else if (ground) begin
            state <= 0;
        end
    end

    wire walking = ~state;
    assign {walk_left, walk_right} = walking ? {~direction, direction} : 2'b00;
    assign aaah = state;

endmodule