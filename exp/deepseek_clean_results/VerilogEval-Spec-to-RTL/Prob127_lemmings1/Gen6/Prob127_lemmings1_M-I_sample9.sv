module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output reg walk_left,
    output reg walk_right
);

    // State encoding
    parameter WALK_LEFT = 1'b0;
    parameter WALK_RIGHT = 1'b1;
    
    reg state;
    reg state_prev;  // For state change detection

    // Combined state transition and reset logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            state_prev <= WALK_LEFT;
        end else begin
            state_prev <= state;  // Store previous state
            case (state)
                WALK_LEFT:  state <= bump_left ? WALK_RIGHT : WALK_LEFT;
                WALK_RIGHT: state <= bump_right ? WALK_LEFT : WALK_RIGHT;
            endcase
        end
    end

    // Output logic - only update when state changes
    always @(*) begin
        if (state != state_prev || areset) begin
            walk_left = (state == WALK_LEFT);
            walk_right = (state == WALK_RIGHT);
        end
    end

endmodule