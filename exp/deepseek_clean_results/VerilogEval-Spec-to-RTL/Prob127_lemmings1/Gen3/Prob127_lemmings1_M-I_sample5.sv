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
    reg next_state;
    reg walk_left_reg;
    reg walk_right_reg;
    reg bump_left_prev;
    reg bump_right_prev;
    wire input_changed;
    wire clk_en;

    // Detect input changes
    assign input_changed = (bump_left != bump_left_prev) || (bump_right != bump_right_prev);
    assign clk_en = input_changed || areset;

    // State transition logic
    always @(*) begin
        case (state)
            WALK_LEFT:  next_state = bump_left ? WALK_RIGHT : WALK_LEFT;
            WALK_RIGHT: next_state = bump_right ? WALK_LEFT : WALK_RIGHT;
        endcase
    end

    // State register with asynchronous reset and clock gating
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            bump_left_prev <= 0;
            bump_right_prev <= 0;
        end else if (clk_en) begin
            state <= next_state;
            bump_left_prev <= bump_left;
            bump_right_prev <= bump_right;
        end
    end

    // Registered outputs to prevent unnecessary toggling
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            walk_left_reg <= 1;
            walk_right_reg <= 0;
        end else begin
            walk_left_reg <= (state == WALK_LEFT);
            walk_right_reg <= (state == WALK_RIGHT);
        end
    end

    assign walk_left = walk_left_reg;
    assign walk_right = walk_right_reg;

endmodule