module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    reg state;  // 0 = left, 1 = right
    reg last_bump_left, last_bump_right;
    wire bump_left_edge = bump_left & ~last_bump_left;
    wire bump_right_edge = bump_right & ~last_bump_right;
    wire toggle = (bump_left_edge | bump_right_edge) & 
                 ~(bump_left_edge & bump_right_edge); // XOR-like behavior

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 0;
            last_bump_left <= 0;
            last_bump_right <= 0;
        end else begin
            last_bump_left <= bump_left;
            last_bump_right <= bump_right;
            if (toggle)
                state <= ~state;
        end
    end

    assign walk_left = ~state;
    assign walk_right = state;

endmodule