module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    output walk_left,
    output walk_right
);

    // State encoding
    parameter WALK_LEFT = 1'b0;
    parameter WALK_RIGHT = 1'b1;
    
    reg state;
    reg state_changed;

    // Combined state transition and reset logic
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            state_changed <= 1'b1; // Reset forces state change
        end else begin
            state_changed <= 1'b0; // Default no change
            case (state)
                WALK_LEFT:  if (bump_left) begin
                                state <= WALK_RIGHT;
                                state_changed <= 1'b1;
                            end
                WALK_RIGHT: if (bump_right) begin
                                state <= WALK_LEFT;
                                state_changed <= 1'b1;
                            end
            endcase
        end
    end

    // Gated output logic - only updates when state changes
    reg walk_left_reg, walk_right_reg;
    always @(posedge clk) begin
        if (state_changed) begin
            walk_left_reg <= (state == WALK_LEFT);
            walk_right_reg <= (state == WALK_RIGHT);
        end
    end

    assign walk_left = walk_left_reg;
    assign walk_right = walk_right_reg;

endmodule