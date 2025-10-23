module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output reg walk_left,
    output reg walk_right,
    output reg aaah
);

reg [1:0] state; // 2'b00: LEFT, 2'b01: RIGHT, 2'b10: FALL
reg prev_dir; // 1: RIGHT, 0: LEFT

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00; // reset to LEFT
        prev_dir <= 1'b0; // reset to LEFT
        walk_left <= 1'b1;
        walk_right <= 1'b0;
        aaah <= 1'b0;
    end else begin
        case (state)
            2'b00: begin // LEFT
                walk_left <= 1'b1;
                walk_right <= 1'b0;
                aaah <= 1'b0;
                if (!ground) begin
                    state <= 2'b10; // transition to FALL
                end else if (bump_left) begin
                    state <= 2'b01; // transition to RIGHT
                    prev_dir <= 1'b0; // set previous direction to LEFT
                end else if (bump_right) begin
                    state <= 2'b01; // transition to RIGHT
                    prev_dir <= 1'b0; // set previous direction to LEFT
                end
            end
            2'b01: begin // RIGHT
                walk_left <= 1'b0;
                walk_right <= 1'b1;
                aaah <= 1'b0;
                if (!ground) begin
                    state <= 2'b10; // transition to FALL
                end else if (bump_left) begin
                    state <= 2'b00; // transition to LEFT
                    prev_dir <= 1'b1; // set previous direction to RIGHT
                end else if (bump_right) begin
                    state <= 2'b00; // transition to LEFT
                    prev_dir <= 1'b1; // set previous direction to RIGHT
                end
            end
            2'b10: begin // FALL
                walk_left <= 1'b0;
                walk_right <= 1'b0;
                aaah <= 1'b1;
                if (ground) begin
                    if (prev_dir) begin
                        state <= 2'b01; // transition to RIGHT
                    end else begin
                        state <= 2'b00; // transition to LEFT
                    end
                end
            end
        endcase
    end
end

endmodule