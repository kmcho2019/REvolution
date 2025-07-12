module TopModule(
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    output reg walk_left,
    output reg walk_right,
    output reg aaah
);

reg [1:0] state; // 0: WALK_LEFT, 1: WALK_RIGHT, 2: FALLING
reg prev_state; // preserve previous walking state

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0; // WALK_LEFT
        prev_state <= 0;
        walk_left <= 1;
        walk_right <= 0;
        aaah <= 0;
    end else begin
        case (state)
            0: begin // WALK_LEFT
                if (bump_left == 1 || (bump_left == 1 && bump_right == 1)) begin
                    state <= 1; // WALK_RIGHT
                end else if (bump_right == 1) begin
                    state <= 1; // WALK_RIGHT
                end else if (ground == 0) begin
                    state <= 2; // FALLING
                    prev_state <= 0;
                end
                walk_left <= 1;
                walk_right <= 0;
                aaah <= 0;
            end
            1: begin // WALK_RIGHT
                if (bump_right == 1 || (bump_left == 1 && bump_right == 1)) begin
                    state <= 0; // WALK_LEFT
                end else if (bump_left == 1) begin
                    state <= 0; // WALK_LEFT
                end else if (ground == 0) begin
                    state <= 2; // FALLING
                    prev_state <= 1;
                end
                walk_left <= 0;
                walk_right <= 1;
                aaah <= 0;
            end
            2: begin // FALLING
                if (ground == 1) begin
                    state <= prev_state; // resume previous walking state
                end
                walk_left <= 0;
                walk_right <= 0;
                aaah <= 1;
            end
        endcase
    end
end

endmodule