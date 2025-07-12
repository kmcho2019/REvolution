module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);

reg [1:0] state; // 0: falling, 1: walking, 2: digging
reg walk_direction; // 0: left, 1: right
reg prev_ground;

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 1; // walking
        walk_direction <= 0; // left
        prev_ground <= 1;
    end else begin
        case (state)
            0: begin // falling
                if (ground) begin
                    state <= 1; // walking
                end
            end
            1: begin // walking
                if (!ground) begin
                    state <= 0; // falling
                end else if (dig) begin
                    state <= 2; // digging
                end else if (bump_left) begin
                    walk_direction <= 1; // right
                end else if (bump_right) begin
                    walk_direction <= 0; // left
                end
            end
            2: begin // digging
                if (!ground) begin
                    state <= 0; // falling
                end
            end
        endcase
        prev_ground <= ground;
    end
end

always_comb begin
    walk_left = (state == 1 && !walk_direction) ? 1'b1 : 1'b0;
    walk_right = (state == 1 && walk_direction) ? 1'b1 : 1'b0;
    aaah = (state == 0) ? 1'b1 : 1'b0;
    digging = (state == 2) ? 1'b1 : 1'b0;
end

endmodule