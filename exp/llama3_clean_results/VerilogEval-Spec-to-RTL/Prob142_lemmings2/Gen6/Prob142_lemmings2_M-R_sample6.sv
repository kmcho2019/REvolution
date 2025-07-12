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

reg [1:0] state; // 2'b00: WALK_LEFT, 2'b01: WALK_RIGHT, 2'b10: FALLING
reg prev_walk_dir; // 0: WALK_LEFT, 1: WALK_RIGHT

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b00; // WALK_LEFT
        prev_walk_dir <= 0;
    end else begin
        case (state)
            2'b00: begin // WALK_LEFT
                if (ground == 0) begin
                    state <= 2'b10; // FALLING
                end else if (bump_left == 1) begin
                    state <= 2'b01; // WALK_RIGHT
                end else if (bump_right == 1) begin
                    // No change in state, but we need to acknowledge the bump
                end else if (bump_left == 1 && bump_right == 1) begin
                    state <= 2'b01; // WALK_RIGHT
                end
            end
            2'b01: begin // WALK_RIGHT
                if (ground == 0) begin
                    state <= 2'b10; // FALLING
                end else if (bump_left == 1) begin
                    state <= 2'b00; // WALK_LEFT
                end else if (bump_right == 1) begin
                    // No change in state, but we need to acknowledge the bump
                end else if (bump_left == 1 && bump_right == 1) begin
                    state <= 2'b00; // WALK_LEFT
                end
            end
            2'b10: begin // FALLING
                if (ground == 1) begin
                    if (prev_walk_dir == 0) begin
                        state <= 2'b00; // WALK_LEFT
                    end else begin
                        state <= 2'b01; // WALK_RIGHT
                    end
                end
            end
        endcase
        if (state == 2'b00) begin
            prev_walk_dir <= 0; // WALK_LEFT
        end else if (state == 2'b01) begin
            prev_walk_dir <= 1; // WALK_RIGHT
        end
    end
end

assign walk_left = (state == 2'b00);
assign walk_right = (state == 2'b01);
assign aaah = (state == 2'b10);

endmodule