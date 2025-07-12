module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    // State encoding (1-bit binary for minimal area)
    parameter LEFT = 1'b0;
    parameter RIGHT = 1'b1;
    
    reg state;

    // State transition and reset logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= LEFT;  // Async reset to left
        end else begin
            case (state)
                LEFT:  state <= bump_left ? RIGHT : LEFT;
                RIGHT: state <= bump_right ? LEFT : RIGHT;
                // Note: Simultaneous bumps will switch direction
                // (handled naturally by the above logic)
            endcase
        end
    end

    // Output logic (Moore style)
    assign walk_left = (state == LEFT);
    assign walk_right = (state == RIGHT);

endmodule