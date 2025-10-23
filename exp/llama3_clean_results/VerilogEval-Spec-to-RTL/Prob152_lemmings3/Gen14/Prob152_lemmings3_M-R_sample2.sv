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

reg [1:0] state; // 0: walking, 1: falling, 2: digging
reg walk_direction; // 0: left, 1: right

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0; // walking
        walk_direction <= 0; // left
    end else begin
        case (state)
            0: begin // walking
                if (!ground) begin
                    state <= 1; // falling
                end else if (dig && ground) begin
                    state <= 2; // digging
                end else if (bump_left) begin
                    walk_direction <= 1; // right
                end else if (bump_right) begin
                    walk_direction <= 0; // left
                end
            end
            1: begin // falling
                if (ground) begin
                    state <= 0; // walking
                end
            end
            2: begin // digging
                if (!ground) begin
                    state <= 1; // falling
                end
            end
        endcase
    end
end

assign walk_left = (state == 0 && !walk_direction) ? 1'b1 : 1'b0;
assign walk_right = (state == 0 && walk_direction) ? 1'b1 : 1'b0;
assign aaah = (state == 1) ? 1'b1 : 1'b0;
assign digging = (state == 2) ? 1'b1 : 1'b0;

endmodule