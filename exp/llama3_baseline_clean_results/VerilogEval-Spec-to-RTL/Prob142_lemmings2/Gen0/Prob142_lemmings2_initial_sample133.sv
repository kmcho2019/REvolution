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

reg [1:0] state; // 0: walking left, 1: walking right, 2: falling
reg prev_dir; // 0: left, 1: right

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0;
        prev_dir <= 0;
        walk_left <= 1;
        walk_right <= 0;
        aaah <= 0;
    end else begin
        case (state)
            0: begin // walking left
                if (~ground) begin
                    state <= 2;
                    prev_dir <= 0;
                    walk_left <= 0;
                    walk_right <= 0;
                    aaah <= 1;
                end else if (bump_left) begin
                    state <= 1;
                    prev_dir <= 0;
                    walk_left <= 0;
                    walk_right <= 1;
                    aaah <= 0;
                end else begin
                    walk_left <= 1;
                    walk_right <= 0;
                    aaah <= 0;
                end
            end
            1: begin // walking right
                if (~ground) begin
                    state <= 2;
                    prev_dir <= 1;
                    walk_left <= 0;
                    walk_right <= 0;
                    aaah <= 1;
                end else if (bump_right) begin
                    state <= 0;
                    prev_dir <= 1;
                    walk_left <= 1;
                    walk_right <= 0;
                    aaah <= 0;
                end else begin
                    walk_left <= 0;
                    walk_right <= 1;
                    aaah <= 0;
                end
            end
            2: begin // falling
                if (ground) begin
                    if (prev_dir == 0) begin
                        state <= 0;
                    end else begin
                        state <= 1;
                    end
                    walk_left <= prev_dir? 0 : 1;
                    walk_right <= prev_dir? 1 : 0;
                    aaah <= 0;
                end else begin
                    walk_left <= 0;
                    walk_right <= 0;
                    aaah <= 1;
                end
            end
        endcase
    end
end

endmodule