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
reg walk_dir; // 0: left, 1: right
reg digging_status;
reg prev_ground;

always_ff @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0; // walking
        walk_dir <= 0; // left
        digging_status <= 0;
        prev_ground <= 1;
    end else begin
        case (state)
            0: begin // walking
                if (!ground) begin
                    state <= 1; // falling
                end else if (dig && ground) begin
                    state <= 2; // digging
                    digging_status <= 1;
                end else if (bump_left) begin
                    walk_dir <= 1; // right
                end else if (bump_right) begin
                    walk_dir <= 0; // left
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
                    digging_status <= 0;
                end else if (dig) begin
                    state <= 2; // continue digging
                end else begin
                    state <= 0; // walking
                    digging_status <= 0;
                end
            end
        endcase
        prev_ground <= ground;
    end
end

always_comb begin
    walk_left = (state == 0 &&!walk_dir)? 1'b1 : 1'b0;
    walk_right = (state == 0 && walk_dir)? 1'b1 : 1'b0;
    aaah = (state == 1)? 1'b1 : 1'b0;
    digging = digging_status;
end

endmodule