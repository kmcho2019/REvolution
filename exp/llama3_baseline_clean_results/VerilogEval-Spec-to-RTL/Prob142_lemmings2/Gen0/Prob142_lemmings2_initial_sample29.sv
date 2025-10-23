module TopModule(
    input           clk,
    input           areset,
    input           bump_left,
    input           bump_right,
    input           ground,
    output          walk_left,
    output          walk_right,
    output          aaah
);

    // Define the states
    enum logic [1:0] {IDLE_LEFT, IDLE_RIGHT, FALL_LEFT, FALL_RIGHT} state, next_state;

    // Sequential logic
    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= IDLE_LEFT;
        end else begin
            state <= next_state;
        end
    end

    // Combinational logic
    always_comb begin
        // Default values
        walk_left = 1'b0;
        walk_right = 1'b0;
        aaah = 1'b0;
        next_state = state;

        case (state)
            IDLE_LEFT: begin
                walk_left = 1'b1;
                if (!ground) begin
                    next_state = FALL_LEFT;
                end else if (bump_left) begin
                    next_state = IDLE_RIGHT;
                end else if (bump_right) begin
                    next_state = IDLE_LEFT; // No change
                end
            end
            IDLE_RIGHT: begin
                walk_right = 1'b1;
                if (!ground) begin
                    next_state = FALL_RIGHT;
                end else if (bump_right) begin
                    next_state = IDLE_LEFT;
                end else if (bump_left) begin
                    next_state = IDLE_RIGHT; // No change
                end
            end
            FALL_LEFT: begin
                aaah = 1'b1;
                if (ground) begin
                    next_state = IDLE_LEFT;
                end
            end
            FALL_RIGHT: begin
                aaah = 1'b1;
                if (ground) begin
                    next_state = IDLE_RIGHT;
                end
            end
        endcase
    end

endmodule