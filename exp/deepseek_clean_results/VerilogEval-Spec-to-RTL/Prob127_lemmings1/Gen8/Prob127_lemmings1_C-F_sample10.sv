module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    // State definitions using localparam
    localparam WALK_LEFT = 1'b0;
    localparam WALK_RIGHT = 1'b1;
    
    reg state;

    // State transition logic with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
        end else begin
            case (state)
                WALK_LEFT:  state <= bump_left ? WALK_RIGHT : WALK_LEFT;
                WALK_RIGHT: state <= bump_right ? WALK_LEFT : WALK_RIGHT;
            endcase
        end
    end

    // Output logic - direct state comparison
    assign walk_left = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);

endmodule