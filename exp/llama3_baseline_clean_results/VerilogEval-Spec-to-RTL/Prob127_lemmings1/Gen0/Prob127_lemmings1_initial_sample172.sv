module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    output walk_left,
    output walk_right
);

    reg [0:0] state;  // 0: WALK_LEFT, 1: WALK_RIGHT
    reg [0:0] next_state;

    always @(*) begin
        case (state)
            0: begin  // WALK_LEFT
                if (bump_left) begin
                    next_state = 1;  // Switch to WALK_RIGHT
                end else begin
                    next_state = 0;  // Stay in WALK_LEFT
                end
            end
            1: begin  // WALK_RIGHT
                if (bump_right) begin
                    next_state = 0;  // Switch to WALK_LEFT
                end else begin
                    next_state = 1;  // Stay in WALK_RIGHT
                end
            end
            default: next_state = 0;
        endcase
    end

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 0;  // Reset to WALK_LEFT
        end else begin
            if (bump_left && bump_right) begin
                state <= ~state;  // Switch direction if bumped from both sides
            end else begin
                state <= next_state;
            end
        end
    end

    assign walk_left = (state == 0);
    assign walk_right = (state == 1);

endmodule