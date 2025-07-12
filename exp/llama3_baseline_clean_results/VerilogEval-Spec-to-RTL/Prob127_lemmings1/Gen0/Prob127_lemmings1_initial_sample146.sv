module TopModule(
    input           clk,
    input           areset,
    input           bump_left,
    input           bump_right,
    output          walk_left,
    output          walk_right
);

    // Define the states
    parameter WALK_LEFT = 1'b0;
    parameter WALK_RIGHT = 1'b1;

    reg current_state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= WALK_LEFT;
        end else if (bump_left) begin
            current_state <= WALK_RIGHT;
        end else if (bump_right) begin
            current_state <= WALK_LEFT;
        end
    end

    // Assign outputs based on the current state
    assign walk_left = (current_state == WALK_LEFT) ? 1'b1 : 1'b0;
    assign walk_right = (current_state == WALK_RIGHT) ? 1'b1 : 1'b0;

endmodule