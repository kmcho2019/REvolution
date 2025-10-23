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

reg [1:0] state; // 0: walking left, 1: walking right, 2: falling
reg prev_state; // to keep track of previous walking direction

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0; // reset to walking left
        prev_state <= 0;
        walk_left <= 1;
        walk_right <= 0;
        aaah <= 0;
    end else begin
        case (state)
            0: begin // walking left
                if (ground == 0) begin
                    state <= 2; // start falling
                    prev_state <= 0;
                end else if (bump_left) begin
                    state <= 1; // change direction to right
                end else if (bump_right) begin
                    // already walking left, do nothing
                end
            end
            1: begin // walking right
                if (ground == 0) begin
                    state <= 2; // start falling
                    prev_state <= 1;
                end else if (bump_left) begin
                    // already walking right, do nothing
                end else if (bump_right) begin
                    state <= 0; // change direction to left
                end
            end
            2: begin // falling
                if (ground == 1) begin
                    state <= prev_state; // resume walking
                end
            end
        endcase
    end
end

always @(*) begin
    case (state)
        0: begin
            walk_left = 1;
            walk_right = 0;
            aaah = 0;
        end
        1: begin
            walk_left = 0;
            walk_right = 1;
            aaah = 0;
        end
        2: begin
            walk_left = 0;
            walk_right = 0;
            aaah = 1;
        end
    endcase
end

endmodule