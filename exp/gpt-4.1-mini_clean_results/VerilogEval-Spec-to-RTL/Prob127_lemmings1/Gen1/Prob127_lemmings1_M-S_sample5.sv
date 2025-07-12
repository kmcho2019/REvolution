module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output reg walk_left,
    output reg walk_right
);

    reg state; // 0 = WALK_LEFT, 1 = WALK_RIGHT

    // Asynchronous reset and state update
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b0; // WALK_LEFT
        else if (bump_left || bump_right)
            state <= ~state; // toggle state
        else
            state <= state; // hold state
    end

    // Output logic (Moore)
    always @(*) begin
        if (state == 1'b0) begin
            walk_left = 1'b1;
            walk_right = 1'b0;
        end else begin
            walk_left = 1'b0;
            walk_right = 1'b1;
        end
    end

endmodule