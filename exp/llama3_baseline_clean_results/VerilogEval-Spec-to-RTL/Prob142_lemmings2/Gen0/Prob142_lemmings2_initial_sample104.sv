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

reg [1:0] state; // 00: WALK_LEFT, 01: WALK_RIGHT, 10: FALL
reg prev_walk_dir; // 1: WALK_LEFT, 0: WALK_RIGHT

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00; // Reset to WALK_LEFT
        prev_walk_dir <= 1'b1; // Reset to WALK_LEFT
        walk_left <= 1'b1;
        walk_right <= 1'b0;
        aaah <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // WALK_LEFT
                walk_left <= 1'b1;
                walk_right <= 1'b0;
                aaah <= 1'b0;
                if (~ground) begin
                    state <= 2'b10; // Transition to FALL
                    prev_walk_dir <= 1'b1; // Save previous walking direction
                end else if (bump_left) begin
                    state <= 2'b01; // Transition to WALK_RIGHT
                end
            end
            2'b01: begin // WALK_RIGHT
                walk_left <= 1'b0;
                walk_right <= 1'b1;
                aaah <= 1'b0;
                if (~ground) begin
                    state <= 2'b10; // Transition to FALL
                    prev_walk_dir <= 1'b0; // Save previous walking direction
                end else if (bump_right) begin
                    state <= 2'b00; // Transition to WALK_LEFT
                end
            end
            2'b10: begin // FALL
                walk_left <= 1'b0;
                walk_right <= 1'b0;
                aaah <= 1'b1;
                if (ground) begin
                    if (prev_walk_dir) begin
                        state <= 2'b00; // Transition to WALK_LEFT
                    end else begin
                        state <= 2'b01; // Transition to WALK_RIGHT
                    end
                end
            end
            default: begin
                state <= 2'b00; // Default to WALK_LEFT
            end
        endcase
    end
end

endmodule