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

reg [1:0] current_state; // 0: walking_left, 1: walking_right, 2: falling, 3: digging
reg direction; // 0: left, 1: right
reg prev_ground;

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= 0; // walking_left
        direction <= 0; // left
        prev_ground <= 1;
    end else begin
        case (current_state)
            0: begin // walking_left
                if (!ground) begin
                    current_state <= 2; // falling
                end else if (dig) begin
                    current_state <= 3; // digging
                end else if (bump_left) begin
                    current_state <= 1; // walking_right
                end else if (bump_right) begin
                    // no change
                end
            end
            1: begin // walking_right
                if (!ground) begin
                    current_state <= 2; // falling
                end else if (dig) begin
                    current_state <= 3; // digging
                end else if (bump_left) begin
                    // no change
                end else if (bump_right) begin
                    current_state <= 0; // walking_left
                end
            end
            2: begin // falling
                if (ground) begin
                    current_state <= direction ? 1 : 0; // walking_right or walking_left
                end
            end
            3: begin // digging
                if (!ground) begin
                    current_state <= 2; // falling
                end
            end
        endcase
        prev_ground <= ground;
    end
end

assign walk_left = (current_state == 0) ? 1'b1 : 1'b0;
assign walk_right = (current_state == 1) ? 1'b1 : 1'b0;
assign aaah = (current_state == 2) ? 1'b1 : 1'b0;
assign digging = (current_state == 3) ? 1'b1 : 1'b0;

endmodule