module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output reg walk_left,
    output reg walk_right,
    output reg aaah,
    output reg digging
);

reg [2:0] state; // 0: walking left, 1: walking right, 2: falling, 3: digging, 4: splattered
reg [5:0] fall_count; // count the number of clock cycles the Lemming has been falling

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0; // reset to walking left
        walk_left <= 1;
        walk_right <= 0;
        aaah <= 0;
        digging <= 0;
        fall_count <= 0;
    end else begin
        case (state)
            0: begin // walking left
                if (!ground) begin
                    state <= 2; // falling
                    walk_left <= 0;
                    walk_right <= 0;
                    aaah <= 1;
                    digging <= 0;
                    fall_count <= 1;
                end else if (dig) begin
                    state <= 3; // digging
                    walk_left <= 0;
                    walk_right <= 0;
                    aaah <= 0;
                    digging <= 1;
                end else if (bump_left) begin
                    state <= 1; // walking right
                    walk_left <= 0;
                    walk_right <= 1;
                    aaah <= 0;
                    digging <= 0;
                end
            end
            1: begin // walking right
                if (!ground) begin
                    state <= 2; // falling
                    walk_left <= 0;
                    walk_right <= 0;
                    aaah <= 1;
                    digging <= 0;
                    fall_count <= 1;
                end else if (dig) begin
                    state <= 3; // digging
                    walk_left <= 0;
                    walk_right <= 0;
                    aaah <= 0;
                    digging <= 1;
                end else if (bump_right) begin
                    state <= 0; // walking left
                    walk_left <= 1;
                    walk_right <= 0;
                    aaah <= 0;
                    digging <= 0;
                end
            end
            2: begin // falling
                if (ground) begin
                    if (fall_count > 20) begin
                        state <= 4; // splattered
                        walk_left <= 0;
                        walk_right <= 0;
                        aaah <= 0;
                        digging <= 0;
                    end else if (state == 0) begin
                        state <= 0; // walking left
                        walk_left <= 1;
                        walk_right <= 0;
                        aaah <= 0;
                        digging <= 0;
                    end else begin
                        state <= 1; // walking right
                        walk_left <= 0;
                        walk_right <= 1;
                        aaah <= 0;
                        digging <= 0;
                    end
                end else begin
                    fall_count <= fall_count + 1;
                end
            end
            3: begin // digging
                if (!ground) begin
                    state <= 2; // falling
                    walk_left <= 0;
                    walk_right <= 0;
                    aaah <= 1;
                    digging <= 0;
                    fall_count <= 1;
                end
            end
            4: begin // splattered
                walk_left <= 0;
                walk_right <= 0;
                aaah <= 0;
                digging <= 0;
            end
        endcase
    end
end

endmodule