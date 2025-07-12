module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    reg walk_left;

    always @(posedge clk or posedge areset) begin
        if (areset)
            walk_left <= 1;
        else if (walk_left)
            walk_left <= ~bump_left;
        else
            walk_left <= bump_right;
    end

    assign walk_right = ~walk_left;

endmodule