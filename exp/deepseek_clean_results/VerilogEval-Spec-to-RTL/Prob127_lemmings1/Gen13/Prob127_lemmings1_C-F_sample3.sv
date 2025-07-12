module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    parameter LEFT = 1'b0;
    parameter RIGHT = 1'b1;
    
    reg state;

    // Optimized state transition logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= LEFT;
        end
        else begin
            case (state)
                LEFT:  state <= bump_left ? RIGHT : LEFT;
                RIGHT: state <= bump_right ? LEFT : RIGHT;
            endcase
        end
    end

    // Direct output assignments
    assign walk_left = (state == LEFT);
    assign walk_right = (state == RIGHT);

endmodule